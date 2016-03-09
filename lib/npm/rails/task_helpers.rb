require "mkmf"
require 'fileutils'

module Npm
  module Rails
    module TaskHelpers

      def self.find_browserify(npm_directory)
        browserify = find_executable0("browserify") ||
          find_executable0("#{ npm_directory }/.bin/browserify")

        if browserify.nil?
          raise Npm::Rails::BrowserifyNotFound, "Browserify not found! You can install Browserify using npm: npm install browserify -g"
        else
          browserify
        end
      end

      def self.create_file(path, file)
        unless File.directory?(path)
          FileUtils.mkdir_p(path)
        end

        file_path = path.join(file)
        FileUtils.touch(file_path)
      end
    end
  end
end
