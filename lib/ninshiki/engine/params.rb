# frozen_string_literal: true
module Ninshiki
  class Engine
    # OpenStruct object that holds parameters of a given validation process
    class Params < OpenStruct
      # @param args [Array] arguments that should match params schema requirements
      def initialize(*args)
        super Schemas::Params.call(*args).output
      end

      # @return [Tempfile] tempfile that has settings details for current validation
      # @note We store it by default inside a file, because some external validators
      #   like rubocop require a config file, some require parameters that we build based
      #   on this file content. By having a file by default, if we need its content we can
      #   just read and parse it.
      def settings_file
        @settings_file ||= Tempfile.new(object_id.to_s).tap do |file|
          file.write(settings_content.to_s)
          file.close
        end
      end

      # @return [Hash] hash with yaml options parsed from settings file
      def settings
        @settings ||= YAML.load(File.open(settings_file).read)
      end
    end
  end
end
