# frozen_string_literal: true

%w[
  ostruct
  yaml
  date
  i18n
  multi_json
  tempfile
  digest/md5
  dry-validation
  require_all
  rugged
  active_support/core_ext/class/subclasses
  active_support/core_ext/class/attribute
  active_support/core_ext/hash/conversions
  active_support/core_ext/hash/indifferent_access
  active_support/descendants_tracker
  active_support/inflector
  support_engine
].each { |lib| require lib }

# Coditsu analytics Engine is responsible for gathering insight about the code
# and how it is being developed
module InsightsEngine
  class << self
    # @return [Array<Class>] all engines that inherit from
    #   InsightsEngine::Engine
    # @example
    #   InsightsEngine.engines #=>
    #   [InsightsEngine::Harvesters::RepositoryAuthors, ...]
    def engines
      InsightsEngine::Engine
        .descendants
        .sort_by(&:to_s)
    end

    # @return [String] root path to this gem
    # @example
    #   InsightsEngine.gem_root #=> '/home/user/.gems/InsightsEngine'
    def gem_root
      File.expand_path('..', __dir__)
    end
  end
end

%w[
  schemas/predicates.rb
  schemas/base.rb
  schemas/*.rb
].each { |path| require_all File.join(File.dirname(__FILE__), 'insights_engine', path) }

%w[
  parser_helper.rb
  parser.rb
  harvester.rb
].each { |path| require_all File.join(File.dirname(__FILE__), '**', path) }

require_all File.dirname(__FILE__) + '/**/*.rb'

# This is used to provide a nicer "Rails like" translations in this gem
# @note This will use language that is defined in the main Rails app
I18n.load_path += Dir[
  File.join(
    InsightsEngine.gem_root, 'config', 'locales', '**', '*.yml'
  )
]
# We need to set language and load translations explicitly if we use
# this gem without the main Coditsu Kabe app. If we use it from the
# main app, all the following settings will be overwritten by its settings
I18n.default_locale = 'en'
I18n.backend.load_translations
