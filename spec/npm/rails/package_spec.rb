require 'spec_helper'

describe Npm::Rails::Package do

  it "creates build_name from name when there is no build_name" do
    package = Npm::Rails::Package.new("original-package-name", "1.0.0")
    expect(package.build_name).to eq "OriginalPackageName"
  end
end
