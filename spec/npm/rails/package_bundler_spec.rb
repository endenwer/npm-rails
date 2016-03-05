require 'spec_helper'

describe Npm::Rails::PackageBundler do

  describe "bundle" do
    let(:root_path) { "root" }
    let(:package_file) { "package_file" }
    let(:env) { double(:env, production?: true) }
    let!(:package_manager) { stub_package_manager }


    describe "when package file exists" do
      before do
        allow(File).to receive(:exist?).with("#{ root_path }/#{ package_file }").and_return true
      end

      it "writes bundle file" do
        Npm::Rails::PackageBundler.bundle(root_path, package_file, env)
        expect(package_manager).to have_received(:write_bundle_file)
      end

      it "calls passed block with arguments"  do
        Npm::Rails::PackageBundler.bundle(root_path, package_file, env) do |packages, bundle_file_path|
          expect(packages).to eq package_manager.to_npm_format
          expect(bundle_file_path).to eq package_manager.write_bundle_file
        end
      end
    end

    describe "when package file does note exist" do
      before do
        allow(File).to receive(:exist?).with("#{ root_path }/#{ package_file }").and_return false
      end

      it "raises error PackageFileNotFound" do
        expect { Npm::Rails::PackageBundler.bundle(root_path, package_file, env) }
          .to raise_error Npm::Rails::PackageFileNotFound
      end
    end
  end


  def stub_package_manager
    package_manager = double(:package_manager,
                             write_bundle_file: "bundle.js",
                             to_npm_format:  "package1-name@1.0.0 pacakge2-name@1.5.0")
    allow(Npm::Rails::PackageManager).to receive(:build).and_return(package_manager)
    package_manager
  end
end
