# frozen_string_literal: true

module LoginRequestHelper
  def log_in(user)
    OmniAuth.config.add_mock(
      :twitter2,
      {
        uid: user.twitter_id,
        info: {
          nickname: user.twitter_screen_name,
          name: user.student.name,
          image: user.image_url,
          description: user.student.description,
          urls: {
            Website: user.student.url,
            Twitter: "https://twitter.com/#{user.twitter_screen_name}",
          },
        },
        credentials: {
          token: 'token',
          expires_at: Time.zone.now.to_i,
        },
      },
    )

    get auth_twitter2_callback_path
  end
end
