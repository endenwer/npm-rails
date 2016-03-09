require 'rails'
require 'coveralls'
require 'npm/rails'
Coveralls.wear!

module Dummy
  # :nodoc:
  class Application < Rails::Application
    config.eager_load = false
  end
end

Rails.application.initialize!

puts Rails.root
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
