require 'spec_helper'

describe Npm::Rails::PackageFileParser do
  let(:spec_directory) { File.expand_path('../../..', __FILE__) }

  describe "parse" do
    let(:packages) { Npm::Rails::PackageFileParser.parse("#{ spec_directory }/fixtures/package_file") }

    it "returns all packages from file" do
      expect(packages.length).to eq 4
    end

    it "marks packages in development block as development" do
      expect(packages[1].development?).to eq true
    end

    it "parses development value" do
      expect(packages[2].development?).to eq true
    end

    it "parses build_name value" do
      expect(packages[3].build_name).to eq "PackageBuildName"
    end
  end
end
