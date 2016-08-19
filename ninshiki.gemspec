lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ninshiki/version'

Gem::Specification.new do |spec|
  spec.name          = 'ninshiki'
  spec.version       = ::Ninshiki::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Maciej Mensfeld']
  spec.email         = %w( maciej@mensfeld.pl )
  spec.homepage      = 'https://coditsu.com'
  spec.summary       = %q{ Insight data harvesting engine for Coditsu Quality Assurance tool }
  spec.description   = %q{ Insight data harvesting engine for Coditsu Quality Assurance tool }
  spec.license       = 'Trade secret'

  spec.add_development_dependency 'bundler'

  spec.add_dependency 'git'
  spec.add_dependency 'rugged'
  spec.add_dependency 'require_all'
  spec.add_dependency 'multi_json'
  spec.add_dependency 'i18n'
  spec.add_dependency 'dry-validation'
  spec.add_dependency 'activesupport'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = %w( lib )
end
