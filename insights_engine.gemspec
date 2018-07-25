# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'insights_engine/version'

Gem.post_install do
  name = :insights_engine
  @post_install_hooks ||= {}
  # This would be executed multiple times if not this check
  unless @post_install_hooks[name]
    success = system "cd #{File.expand_path(__dir__)} && yarn"
    raise Gem::DependencyError, name unless success
    @post_install_hooks[name] = true
  end
end

Gem::Specification.new do |spec|
  spec.name         = 'insights_engine'
  spec.version      = ::InsightsEngine::VERSION
  spec.platform     = Gem::Platform::RUBY
  spec.authors      = ['Maciej Mensfeld']
  spec.email        = %w[maciej@mensfeld.pl]
  spec.homepage     = 'https://coditsu.com'
  spec.summary      = 'Insight engine for Coditsu Quality Assurance tool'
  spec.description  = 'Insight engine for Coditsu Quality Assurance tool'
  spec.license      = 'Trade secret'

  spec.add_development_dependency 'bundler'

  spec.add_dependency 'activesupport'
  spec.add_dependency 'dry-validation'
  spec.add_dependency 'git'
  spec.add_dependency 'github-linguist'
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
