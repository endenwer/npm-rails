require "rails"
require "rails/railtie"

module Npm
  module Rails
    class Railtie < ::Rails::Railtie
      config.npm = ActiveSupport::OrderedOptions.new
      config.npm.package_file = "npm_packages"

      output_path = "vendor/assets/javascripts/npm-rails"
      if ::Rails.env.production?
        config.npm.output_path = output_path << "/production"
      else
        config.npm.output_path = output_path << "/development"
      end

      initializer "npm_rails.add_assets_path", after: :engines_blank_point, group: :all do |app|
        app.config.assets.paths << app.config.npm.output_path
      end

      rake_tasks do
        load "tasks/npm.rake"
      end
    end
  end
end
