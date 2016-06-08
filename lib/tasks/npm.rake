require 'fileutils'

namespace :npm do
  desc "Install npm packages"
  task :install do
    package_file = ::Rails.configuration.npm.package_file
    browserify_options = ::Rails.configuration.npm.browserify_options
    output_path = ::Rails.root.join(::Rails.configuration.npm.output_path)
    output_file = "npm-dependencies.js"
    output_file_path = output_path.join(output_file)

    Npm::Rails::TaskHelpers.create_file(output_path, output_file) unless File.exist?(output_file_path)

    Npm::Rails::PackageBundler.bundle(::Rails.root, package_file, ::Rails.env) do |packages, bundle_file_path|
      sh "npm install --prefix #{ ::Rails.root } --loglevel error #{ packages }"

      browserify = Npm::Rails::TaskHelpers.find_browserify(::Rails.root.join("node_modules"))
      browserify_command = "#{ browserify } #{ browserify_options } #{ bundle_file_path } > #{ output_file_path }"
      if Rails.env.production?
        browserify_command = "NODE_ENV=production #{ browserify_command }"
      end

      sh browserify_command
    end
  end
end

if ::Rails.configuration.npm.run_before_assets_precompile
  task "assets:precompile" => ["npm:install"]
end
