require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Searchapp
  class Application < Rails::Application
    config.load_defaults 5.1

    config.assets.initialize_on_precompile = false
    config.action_controller.perform_caching = false
  end
end
