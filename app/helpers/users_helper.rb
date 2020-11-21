# frozen_string_literal: true

module UsersHelper
  def link_to_twitter_profile_with_image(user)
    link_to twitter_profile_url(user.twitter_screen_name), target: '_blank', rel: 'noopener' do
      image_tag user.image_url,
                size: '24x24',
                class: 'border rounded-circle',
                data: { toggle: 'tooltip', placement: 'top', controller: 'tooltip' },
                title: user.twitter_screen_name
    end
  end
end
