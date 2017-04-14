# frozen_string_literal: true

require 'active_support/core_ext/object/deep_dup'

module SchemasSpec
  class Input
    class << self
      def nested?(string)
        string.to_s.include?('.')
      end

      def nested_scope(string)
        string.to_s.split('.').map(&:to_sym)
      end

      def change_nested(input, hash)
        scope = nested_scope(hash[:name])
        name = scope.pop
        tmp = nil
        tmp = input[scope.shift] until scope.empty?
        tmp = tmp.first if tmp.instance_of?(Array)
        tmp[name] = hash[:value]
      end

      def change_normal(input, hash)
        if hash[:scope]
          input[hash[:scope]].first[hash[:name]] = hash[:value]
        else
          input[hash[:name]] = hash[:value]
        end
        input[hash[:name]] = hash[:value]
      end

      def change(hash)
        input = hash[:input].deep_dup

        if nested?(hash[:name])
          change_nested(input, hash)
        else
          change_normal(input, hash)
        end

        input
      end
    end
  end
end
