# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

%w[
  support_engine
].each do |gem_name|
  gem gem_name,
      git: "git@github.com:coditsu/#{gem_name.tr('_', '-')}.git",
      require: true,
      branch: :master
end

group :development, :test do
  gem 'byebug'
  gem 'irb'
  gem 'rspec'
  gem 'simplecov'
  gem 'timecop'
end
