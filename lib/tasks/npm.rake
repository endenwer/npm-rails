require 'fileutils'
require "mkmf"

namespace :npm do
  desc "Install npm packages"
  task :install do
    package_file = ::Rails.configuration.npm.package_file
    output_file_path = ::Rails.root.join(::Rails.configuration.npm.output_file)
    browserify_options = ::Rails.configuration.npm.browserify_options

    Npm::Rails::PackageBundler.bundle(::Rails.root, package_file, ::Rails.env) do |packages, bundle_file_path|
      FileUtils.touch(output_file_path) unless File.exist?(output_file_path)
      sh "cd #{ ::Rails.root }"
      sh "npm install --loglevel error #{ packages }"

      browserify = find_executable0("browserify") ||
        find_executable0("#{ ::Rails.root }/node_modules/.bin/browserify")

      if browserify.nil?
        raise Npm::Rails::BrowserifyNotFound, "Browserify not found! You can install Browserify using npm: npm install browserify -g"
      end

      if Rails.env.production?
        browserify_comamnd = "NODE_ENV=production #{ browserify } #{ browserify_options } #{ bundle_file_path } > #{ output_file_path }"
      else
        browserify_command = "#{ browserify } #{ browserify_options } #{ bundle_file_path } > #{ output_file_path }"
      end

      sh browserify_command
    end
  end
end

task "assets:precompile" => ["npm:install"]
