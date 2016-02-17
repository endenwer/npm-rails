require 'spec_helper'

describe Npm::Rails::PackageFileParser do
  let(:spec_directory) { File.expand_path('../../..', __FILE__) }

  describe "parse" do
    let(:packages) { Npm::Rails::PackageFileParser.parse("#{ spec_directory }/fixtures/package_file") }

    it "returns all packages from file" do
      expect(packages.length).to eq 2
    end

    it "marks packages in development block as development" do
      expect(packages[1].development?).to eq true
    end
  end
end
