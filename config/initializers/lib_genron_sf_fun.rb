# frozen_string_literal: true

Dir[Rails.root.join('lib/genron_sf_fun/**/*.rb')].sort.each { |f| require f }
