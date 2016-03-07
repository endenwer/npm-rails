module Npm
  module Rails
    class PackageFileParser

      attr_reader :packages

      def self.parse(package_file_path)
        parser = new
        parser.parse(package_file_path)
        parser.packages
      end

      def initialize
        @packages = []
        @development = false
      end

      def parse(package_file_path)
       @package_file = File.open(package_file_path, "r", &:read)
       eval(@package_file)
      end

      private

      def npm(package_name, *args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        options = { development: @development }.merge(options)
        version = args.empty? ? "latest" : args.pop

        @packages << Npm::Rails::Package.new(package_name, version, options)
      end

      def development
        @development = true
        yield
        @development = false
      end
    end
  end
end
