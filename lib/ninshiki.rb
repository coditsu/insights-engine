# frozen_string_literal: true
%w(
  open3
  ostruct
  yaml
  date
  i18n
  multi_json
  tempfile
  digest/md5
  dry-validation
  require_all
  active_support/core_ext/class/subclasses
  active_support/core_ext/class/attribute
  active_support/core_ext/hash/conversions
  active_support/core_ext/hash/indifferent_access
  active_support/descendants_tracker
  active_support/inflector
).each { |lib| require lib }

# Coditsu analytics Engine responsible for gathering insight about the code and how it is being
# developed
module Ninshiki
  class << self
    # @return [Array<Class>] all engines that inherit from Ninshiki::Engine
    # @example
    #   Ninshiki.engines #=> [Ninshiki::Harvesters::RepositoryAuthors, ...]
    def engines
      Ninshiki::Engine
        .descendants
        .sort { |c1, c2| c1.to_s <=> c2.to_s }
    end

    # @return [String] root path to this gem
    # @example
    #   Ninshiki.gem_root #=> '/home/user/.gems/Ninshiki'
    def gem_root
      File.expand_path('../..', __FILE__)
    end
  end
end

require_all File.dirname(__FILE__) + '/**/*.rb'

# This is used to provide a nicer "Rails like" translations in this gem
# @note This will use language that is defined in the main Rails app
I18n.load_path += Dir[
  File.join(
    Ninshiki.gem_root, 'config', 'locales', '**', '*.yml'
  )
]
# We need to set language and load translations explicitely if we use
# this gem without the main Coditsu Kabe app. If we use it from the
# main app, all the following settings will be overwritten by its settings
I18n.default_locale = 'en'
I18n.backend.load_translations
