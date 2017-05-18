# frozen_string_literal: true

require 'active_support/core_ext/object/deep_dup'

module SchemasSpec
  # Wrapper for changing values for tested attribute
  class Input
    class << self
      # Changes attribute value for test purposes
      # @param hash [Hash] test configuration for given attribute
      # @return [Hash] input hash with changed attribute value
      # @example
      #   hash = {
      #     :name => "author.name",
      #     :predicates => [:optional, :maybe, :str?],
      #     :scope => nil,
      #     :predicate => :optional,
      #     :predicate_value => 0,
      #     :input =>
      #     {
      #       :commit_hash => "b2a540b5aad4b5a6851687eff99f9b831c8b6906",
      #       :message => "gem bump\n",
      #       :authored_at => Sat, 13 May 2017 19:14:37 +0200,
      #       :committed_at => Sat, 13 May 2017 19:14:37 +0200,
      #       :author => { :name => "xxx", :email => "xxx@xxx.pl" },
      #       :committer => { :name => "xxx", :email => "xxx@xxx.pl" },
      #       :files_changed => 1,
      #       :insertions => 1,
      #       :deletions => 1
      #     },
      #    :value => nil
      #   }
      #   change(hash) #=>
      #   {
      #     ...
      #     :input =>
      #     {
      #       ...
      #       :author => { :name => nil, :email => "xxx@xxx.pl" },
      #       ...
      #     },
      #    :value => nil
      #   }
      def change(hash)
        input = hash[:input].deep_dup

        if nested?(hash[:name])
          change_nested(input, hash)
        else
          change_normal(input, hash)
        end

        input
      end

      private

      # Detects if it is a nested attribute name
      # @param string [String] attribute name
      # @return [Boolean] true if it is nested
      # @example
      #   nested?("author.name") #=> true
      def nested?(string)
        string.to_s.include?('.')
      end

      # Creates array from nested attribute
      # @param string [String] attribute name
      # @return [Array<String>] nested attribute names
      # @example
      #   nested_scope("author.name") #=> [:author, :name]
      def nested_scope(string)
        string.to_s.split('.').map(&:to_sym)
      end

      # Changes attribute value on nested attribute
      # @param input [Hash] dupped input hash
      # @param hash [Hash] test configuration for given attribute
      def change_nested(input, hash)
        scope = nested_scope(hash[:name])
        name = scope.pop
        tmp = nil
        tmp = input[scope.shift] until scope.empty?
        tmp = tmp.first if tmp.instance_of?(Array)
        tmp[name] = hash[:value]
      end

      # Changes attribute value on normal attribute
      # @param input [Hash] dupped input hash
      # @param hash [Hash] test configuration for given attribute
      def change_normal(input, hash)
        if hash[:scope]
          input[hash[:scope]].first[hash[:name]] = hash[:value]
        else
          input[hash[:name]] = hash[:value]
        end
        input[hash[:name]] = hash[:value]
      end
    end
  end
end
