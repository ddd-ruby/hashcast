require 'rubygems'
require 'bundler/setup'

require "byebug"


require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/.direnv/"
  add_filter "/hcast/concern" # copy from ActiveSupport
end
if ENV['CI']=='true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require 'hashcast'
RSpec.configure do |config|
  config.color_enabled = true
end
