require 'spec_helper'

describe Npm::Rails::PackageManager do
  let!(:package_for_all_environment) do
    double(:package_for_all_environment,
          name: "package-for-all-environment",
          development?: false,
          build_name: "PackageForAllEnvironment",
          should_require?: true,
          version: "1.0.0")
  end

  let!(:package_for_development) do
    double(:package_for_development,
          name: "package-for-development",
          development?: true,
          build_name: "PackageForDevelopment",
          should_require?: true,
          version: "1.0.0")
  end

  let!(:package_with_require_false) do
    double(:package_with_require_false,
          name: "package-with-require-false",
          development?: false,
          build_name: "PackageWithRequireFalse",
          should_require?: false,
          version: "1.0.0")
  end

  let(:packages) do
    [ package_for_all_environment,
      package_for_development,
      package_with_require_false, ]
  end

  let(:production_env) { double(:production_env, production?: true, development?: false) }
  let(:development_env) { double(:development_env, production?: false, development?: true) }

  before do
    allow(File).to receive(:exist?).with("tmp/npm-rails").and_return true
  end

  describe "write_bundle_file" do
    let!(:file_buffer) { stub_file_writing }

    context "for production" do
      it "writes packages for all environment" do
        Npm::Rails::PackageManager.new([package_for_all_environment], "root_path", production_env).write_bundle_file
        expect(file_buffer.string).to match /^window\.PackageForAllEnvironment = require\('package-for-all-environment'\)$/
      end

      it "does not write development packages" do
        Npm::Rails::PackageManager.new([package_for_development], "root_path", production_env).write_bundle_file
        expect(file_buffer).to_not match /PackageForDevelopment/
      end

      it "does not write packages with { require: false }" do
        Npm::Rails::PackageManager.new([package_with_require_false], "root_path", production_env).write_bundle_file
        expect(file_buffer).to_not match /PackageWithRequireFalse/
      end
    end

    context "for development" do
      it "writes packages for all environment" do
        Npm::Rails::PackageManager.new([package_for_all_environment], "root_path", development_env).write_bundle_file
        expect(file_buffer.string).to match /^window\.PackageForAllEnvironment = require\('package-for-all-environment'\)$/
      end

      it "writes development packages" do
        Npm::Rails::PackageManager.new([package_for_development], "root_path", development_env).write_bundle_file
        expect(file_buffer.string).to match /^window\.PackageForDevelopment = require\('package-for-development'\)$/
      end

      it "does not write packages with { require: false }" do
        Npm::Rails::PackageManager.new([package_with_require_false], "root_path", development_env).write_bundle_file
        expect(file_buffer).to_not match /PackageWithRequireFalse/
      end
    end
  end

  describe "to_npm_format" do
    context "for production" do
      it "returns string with packages for 'nmp install' command without development packages" do
        package_manager = Npm::Rails::PackageManager.new(packages, "root_path", production_env)
        result = "package-for-all-environment@\"1.0.0\" package-with-require-false@\"1.0.0\" "
        expect(package_manager.to_npm_format).to eq result
      end
    end

    context "for development" do
      it "returns string with all packages for 'npm install ' command" do
        package_manager = Npm::Rails::PackageManager.new(packages, "root_path", development_env)
        result = "package-for-all-environment@\"1.0.0\" package-for-development@\"1.0.0\" package-with-require-false@\"1.0.0\" "
        expect(package_manager.to_npm_format).to eq result
      end
    end
  end

  def stub_file_writing
    StringIO.new.tap do |buffer|
      allow(File).to receive(:open).and_yield(buffer)
    end
  end
end
