# frozen_string_literal: true

module OmniAuth
  module Strategies
    class TwitterDev
      include OmniAuth::Strategy

      option :name, 'twitter_dev'

      def request_phase
        form = OmniAuth::Form.new(title: 'Twitter Dev', url: callback_path)
        form.text_field 'ID', 'id'
        form.text_field 'Screen name', 'screen_name'
        form.button 'Sign In'
        form.to_response
      end

      uid do
        request.params['id']
      end

      info do
        screen_name = request.params['screen_name']
        {
          id: request.params['id'],
          name: screen_name,
          nickname: screen_name,
          image: "https://robohash.org/#{screen_name}.png?size=72x72",
          description: nil,
          urls: {
            'Twitter': "https://twitter.com/#{screen_name}",
            'Website': nil,
          },
        }
      end
    end
  end
end
