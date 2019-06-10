# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'insights_engine/version'

Gem::Specification.new do |spec|
  spec.name         = 'insights_engine'
  spec.version      = ::InsightsEngine::VERSION
  spec.platform     = Gem::Platform::RUBY
  spec.authors      = ['Maciej Mensfeld']
  spec.email        = %w[contact@coditsu.io]
  spec.homepage     = 'https://coditsu.io'
  spec.summary      = 'Insight engine for Coditsu Quality Assurance tool'
  spec.description  = 'Insight engine for Coditsu Quality Assurance tool'
  spec.license      = 'LGPL-3.0'

  spec.add_development_dependency 'bundler'

  spec.add_dependency 'activesupport'
  spec.add_dependency 'dry-validation'
  spec.add_dependency 'i18n'
  spec.add_dependency 'multi_json'
  spec.add_dependency 'require_all'
  spec.add_dependency 'rugged'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(spec)/})
  end
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]
end
