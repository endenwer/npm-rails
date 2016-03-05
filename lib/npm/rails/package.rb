module Npm
  module Rails
    class Package

      attr_reader :name
      attr_reader :version
      attr_reader :build_name

      def initialize(name, version, options = {})
        @name = name
        @version = version
        @development = options.fetch(:development, false)
        @build_name = options.fetch(:build_name, create_build_name_from_name)
        @require = options.fetch(:require, true)
      end

      def development?
        @development
      end

      def should_require?
        @require
      end

      private

      def create_build_name_from_name
        @name.tr("-", "_").camelize
      end
    end
  end
end
