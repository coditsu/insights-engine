# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

%w[
  rubygems
  simplecov
  support_engine
  support_engine/git/repo_builder
  support_engine/rspec_locator
].each do |lib|
  require lib
end

# Don't include unnecessary stuff into coverage
SimpleCov.start do
  add_filter '/.bundle/'
  add_filter '/doc/'
  add_filter '/spec/'
  add_filter '/config/'
  merge_timeout 600
end

Time.zone = 'UTC'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.order = :random

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.before(:suite) do
    # In order to check that mirroring works, we need to bootstrap a dummy repository
    # with some commits in master and non-master branch to ensure that mirroring works
    SupportEngine::Git::RepoBuilder.bootstrap
  end

  config.after(:suite) do
    # Cleanup of dummy repo and test tmp sources path so we don't leave behind
    # garbage cloned test repositories
    SupportEngine::Git::RepoBuilder.destroy
  end
end

require 'insights_engine'

# We remove this because we test each validator also on
# the repository source code
FileUtils.rm_rf(File.join(InsightsEngine.gem_root, 'coverage'))
FileUtils.rm_rf(File.join(InsightsEngine.gem_root, '.yardoc'))
FileUtils.rm_rf(File.join(InsightsEngine.gem_root, 'doc'))

RSpec.extend SupportEngine::RSpecLocator.new(__FILE__)
