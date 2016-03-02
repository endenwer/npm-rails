module Npm
  module Rails
    class PackageManager

      def self.build(root_path, package_file, env)
        package_file_path = "#{ root_path }/#{ package_file }"
        packages = PackageFileParser.parse(package_file_path)
        new(packages, root_path, env)
      end

      def initialize(packages, root_path, env)
        @packages = packages
        @root_path = root_path
        @env = env
      end

      def write_bundle_file
        bundle_file_path = "#{ @root_path }/tmp/npm-rails/bundle.js"
        Dir.mkdir("tmp/npm-rails") unless File.exist?("tmp/npm-rails")
        File.open(bundle_file_path, "w") do |file|
          packages_for_bundle_file.each do |package|
            file.write "window.#{ package.build_name } = require('#{ package.name }')\n"
          end
        end
        bundle_file_path
      end

      # Return string of packages for 'npm install' command
      def to_npm_format
        @packages.inject "" do |string, package|
          # do not add development packages in production environment
          if (@env.production? and package.development?)
            string
          else
            string << "#{ package.name }@\"#{ package.version }\" "
          end
        end
      end

      private

      def packages_for_bundle_file
        if @env.production?
          @packages.select do |package|
            package.should_require? && !package.development?
          end
        else
          @packages.select do |package|
            package.should_require?
          end
        end
      end
    end
  end
end
