require "mkmf"

module Npm
  module Rails
    class PackageBundler

      def self.bundle(root_path, package_file, env, &block)
        new.bundle(root_path, package_file, env, &block)
      end

      def bundle(root_path, package_file, env, &block)
        @root_path = root_path
        @package_file = package_file
        @env = env
        browserify = find_executable0("browserify") ||
                     find_executable0("#{ root_path }/node_modules/.bin/browserify")

        if browserify.nil?
          raise BrowserifyNotFound, "Browserify not found! You can install Browserify using npm: npm install browserify -g"
        end

        if File.exist?("#{ root_path }/#{ package_file }")
          bundle_file_path = package_manager.write_bundle_file
          if block_given?
            yield browserify, package_manager.to_npm_format, bundle_file_path
          end
        else
          raise PackageFileNotFound, "#{ package_file } not found! Make sure you have it at the root of your project"
        end
      end

      private

      def package_manager
        @package_manager ||= PackageManager.build(@root_path, @package_file, @env)
      end
    end
  end
end
