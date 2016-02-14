require "rails"
require "rails/railtie"

module Npm
  module Rails
    class Railtie < ::Rails::Railtie
      config.npm = ActiveSupport::OrderedOptions.new
      config.npm.directory = "npm"
      config.npm.packages_file = "npm_packages"

      initializer "npm_rails.setup_vendor" do |app|
        browserify_output_directory = Rails.root.join("#{ app.config.npm.directory }/generated")
        if Rails.env.production?
          app.config.assets.append_path("#{ browserify_output_directory  }/prod-bundle")
        else
          app.config.assets.append_path("#{ browserify_output_direcotry  }/dev-bundle")
        end
      end

      rake_tasks do
        load "tasks/npm.rake"
      end
    end
  end
end
