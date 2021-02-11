# frozen_string_literal: true

class TweetImportedJob < ApplicationJob
  def perform
    Term.last.kadais.where(tweet_url: nil).each do |kadai|
      tweet = post_tweet(kadai_tweet_text(kadai))
      kadai.update!(tweet_url: tweet.url) if tweet
    end

    works = Work.where(kadai: Kadai.newest3, tweet_url: nil).where.not(genron_sf_id: nil).order(:id)
    works.includes(student: :user).each do |work|
      tweet = post_tweet(work_tweet_text(work))
      work.update!(tweet_url: tweet.url) if tweet
    end
  end

  private

  def kadai_tweet_text(kadai)
    lines = []
    lines << "【課題】 第#{kadai.round}回「#{kadai.title}」"
    lines << "課題提示: #{kadai.author}" if kadai.author.present?
    lines << "梗概締切: #{I18n.l(kadai.kougai_deadline, format: :long)}" if kadai.kougai_deadline
    lines << "実作締切: #{I18n.l(kadai.jissaku_deadline, format: :long)}" if kadai.jissaku_deadline
    lines << '#SF創作講座 #裏SF創作講座'
    lines << kadai.genron_sf_url
    lines << "https://genron-sf-fun.herokuapp.com/#{kadai.year}/#{kadai.round}"
    lines.join("\n")
  end

  def work_tweet_text(work)
    lines = []
    lines << if work.student.user
               "【#{work.class.model_name.human}】#{work.student.name} @#{work.student.user.twitter_screen_name}『#{work.title}』" # rubocop:disable Layout/LineLength
             else
               "【#{work.class.model_name.human}】#{work.student.name}『#{work.title}』"
             end
    lines << '#SF創作講座'
    lines << work.url
    lines.join("\n")
  end

  def post_tweet(text)
    GenronSFFun::TwitterClient.instance.update(text)
  rescue Twitter::Error => e
    Sentry.capture_exception(e, extra: { tweet_text: text }, hint: { background: false })
    nil
  end
end
