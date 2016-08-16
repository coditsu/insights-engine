# frozen_string_literal: true
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

%w(
  rubygems
  simplecov
  rake
  timecop
).each do |lib|
  require lib
end

# Don't include unnecessary stuff into rcov
SimpleCov.start do
  add_filter '/.bundle/'
  add_filter '/doc/'
  add_filter '/spec/'
  add_filter '/config/'
  merge_timeout 600
end

Timecop.safe_mode = true

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end

require 'Ninshiki'

# We remove this because we test each validator also on the repository source code
FileUtils.rm_rf(File.join(Ninshiki.gem_root, 'coverage'))
FileUtils.rm_rf(File.join(Ninshiki.gem_root, '.yardoc'))
FileUtils.rm_rf(File.join(Ninshiki.gem_root, 'doc'))
