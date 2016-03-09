require 'spec_helper'

describe Npm::Rails::TaskHelpers do
  subject { Npm::Rails::TaskHelpers }

  describe "find_browserify" do
    it "returns browserify if it installed globally" do
      stub_find_executable0("browserify", "browserify")
      stub_find_executable0("npm_directory/.bin/browserify", nil)
      expect(subject.find_browserify("npm_directory")). to eq "browserify"
    end

    it "returns browserify if it installed locally" do
      browserify = "npm_directory/.bin/browserify"
      stub_find_executable0("browserify", nil)
      stub_find_executable0(browserify, browserify)
      expect(subject.find_browserify("npm_directory")). to eq browserify
    end

    it "raise BrowserifyNotFound if browserify does not exist" do
      allow_any_instance_of(MakeMakefile).to receive(:find_executable0).and_return nil
      expect{ subject.find_browserify("npm_directory") }.to raise_error Npm::Rails::BrowserifyNotFound
    end
  end

  def stub_find_executable0(receive_value, return_value)
    allow_any_instance_of(MakeMakefile).to receive(:find_executable0).with(receive_value).and_return return_value
  end
end
