require "rails"
require "rails/railtie"

module Npm
  module Rails
    class Railtie < ::Rails::Railtie
      config.npm = ActiveSupport::OrderedOptions.new
      config.npm.package_file = "npm_packages"
      config.npm.output_file = "vendor/assets/javascripts/npm-dependencies.js"

      rake_tasks do
        load "tasks/npm.rake"
      end
    end
  end
end
