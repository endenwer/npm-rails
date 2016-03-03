require 'fileutils'

namespace :npm do
  desc "Install npm packages"
  task :install do
    package_file = ::Rails.configuration.npm.package_file
    output_file_path = ::Rails.root.join(::Rails.configuration.npm.output_file)
    browserify_options = ::Rails.configuration.npm.browserify_options

    Npm::Rails::PackageBundler.bundle(::Rails.root, package_file, ::Rails.env) do |browserify, packages, bundle_file_path|
      FileUtils.touch(output_file_path) unless File.exist?(output_file_path)
      if Rails.env.production?
        browserify_comamnd = "NODE_ENV=production #{ browserify } #{ browserify_options } #{ bundle_file_path } > #{ output_file_path }"
      else
        browserify_command = "#{ browserify } #{ browserify_options } #{ bundle_file_path } > #{ output_file_path }"
      end
      sh "cd #{ ::Rails.root }"
      sh "npm install --loglevel error #{ packages }"
      sh browserify_command
    end
  end
end

task "assets:precompile" => ["npm:install"]
