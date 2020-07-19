# frozen_string_literal: true

OpenGraphReader.configure do |config|
  config.validate_required = false
  config.discard_invalid_optional_properties = true
  config.synthesize_title = true
  config.synthesize_url = true
  config.synthesize_full_url = true
  config.guess_datetime_format = true
end
