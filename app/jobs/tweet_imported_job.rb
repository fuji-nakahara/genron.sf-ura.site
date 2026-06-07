# frozen_string_literal: true

class TweetImportedJob < ApplicationJob
  include Twitter::TwitterText::Validation

  MAX_TWEET_WEIGHTED_LENGTH = 270
  Error = Class.new(StandardError)

  def perform
    failed = { kadai_ids: [], work_ids: [] }

    Term.last.kadais.where(tweet_id: nil).find_each do |kadai|
      tweet = post_tweet(kadai_tweet_text(kadai))
      if tweet
        kadai.update!(tweet_id: tweet.fetch('data').fetch('id'))
      else
        failed[:kadai_ids] << kadai.id
      end
    end

    works = Work.where(kadai: Kadai.newest3, tweet_id: nil).where.not(genron_sf_id: nil).order(:id)
    works.includes(:kadai, student: :user)
         .group_by { |work| [work.kadai, work.type] }
         .each do |(kadai, type), grouped_works|
      if kadai.tweet_id.nil?
        failed[:work_ids] += grouped_works.map(&:id)
        next
      end

      work_tweet_chunks(type, grouped_works).each do |text, chunk_works|
        tweet = post_tweet(text, reply_to: kadai.tweet_id)
        if tweet
          chunk_works.each { |work| work.update!(tweet_id: tweet.fetch('data').fetch('id')) }
        else
          failed[:work_ids] += chunk_works.map(&:id)
        end
      end
    end

    raise Error, "Failed to tweet: #{failed}" if failed.values.any?(&:present?)
  end

  private

  def kadai_tweet_text(kadai)
    lines = []
    lines << "【課題】 第#{kadai.round}回「#{kadai.title}」"
    lines << "課題提示: #{kadai.author}" if kadai.author.present?
    lines << "梗概締切: #{I18n.l(kadai.kougai_deadline, format: :long)}" if kadai.kougai_deadline
    lines << "実作締切: #{I18n.l(kadai.jissaku_deadline, format: :long)}" if kadai.jissaku_deadline
    lines << '#SF創作講座 #裏SF創作講座'
    lines << kadai.url
    lines << "https://genron.sf-ura.site/#{kadai.year}/#{kadai.round}"
    lines.join("\n")
  end

  def work_tweet_chunks(type, works)
    chunks = []
    lines = []
    chunk_works = []

    works.each do |work|
      line = work_tweet_line(work)
      next_text = work_tweet_text(type, lines + [line])
      tweet_weighted_length = parse_tweet(next_text)[:weighted_length]
      if lines.present? && tweet_weighted_length > MAX_TWEET_WEIGHTED_LENGTH
        chunks << [work_tweet_text(type, lines), chunk_works]
        lines = []
        chunk_works = []
      end

      lines << line
      chunk_works << work
    end

    chunks << [work_tweet_text(type, lines), chunk_works] if lines.present?
    chunks
  end

  def work_tweet_line(work)
    author = work.student.name
    author = "#{author} @#{work.student.user.twitter_screen_name}" if work.student.user
    "#{author}『#{work.title}』"
  end

  def work_tweet_text(type, lines)
    header = "#{type.constantize.model_name.human}が投稿されました！"
    footer = '#SF創作講座'
    ([header] + lines + [footer]).join("\n")
  end

  def post_tweet(text, reply_to: nil)
    if reply_to
      Rails.configuration.x.twitter_client.tweet(text, reply_to:)
    else
      Rails.configuration.x.twitter_client.tweet(text)
    end
  rescue TwitterClient::Error => e
    Sentry.capture_exception(e, extra: { tweet_text: text }, hint: { background: false })
    nil
  end
end
