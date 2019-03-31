# frozen_string_literal: true

module SchemasSpec
  class Predicate
    # Integer predicate schema test builder
    class Integer
      # Define test cases for integer based on predicate
      CONFIG = {
        lt?: {
          success: {
            int?: [[:substract, 5]],
            lt?: [[:substract, 5]]
          },
          error: {
            lt?: [:same, [:add, 5]]
          }
        },
        lteq?: {
          success: {
            int?: [:same],
            lteq?: [:same, [:substract, 5]]
          },
          error: {
            lteq?: [[:add, 5]]
          }
        },
        gt?: {
          success: {
            int?: [[:add, 5]],
            gt?: [[:add, 5]]
          },
          error: {
            gt?: [:same, [:substract, 5]]
          }
        },
        gteq?: {
          success: {
            int?: [:same],
            gteq?: [:same, [:add, 5]]
          },
          error: {
            gteq?: [[:substract, 5]]
          }
        }
      }.freeze

      class << self
        # Builds integer predicate test cases
        # @param object [Hash] configuration on which validation should succeed and error
        # @param predicates [Hash] predicates for the attribute from schema
        # @return [Hash] schema like configuration with modified values for integer predicates
        def build!(object, predicates)
          object.merge!(
            CONFIG.each_with_object({}) do |(predicate, types), hash|
              value = fetch_value(predicate, predicates)
              next unless value

              hash.merge!(build_type(value, types))
            end
          )
        end

        private

        # Fetches value for integer predicate
        # @param key [Symbol] predicate name
        # @param predicates [Hash] predicates for the attribute from schema
        # @return [Integer] attribute predicate value from schema
        # @example
        #   build(:gteq?, [:required, :filled, :int?, {:gteq?=>0}]) #=> 0
        def fetch_value(key, predicates)
          match = predicates.select { |p| p.to_s.include?(key.to_s) }
          return if match.empty?

          # [{:gteq?=>10}] => 10
          match.first.to_a.flatten.last
        end

        # Calculates predicate value for given test case
        # @param predicate_value [Integer] predicate value from schema
        # @param value [Symbol, Array<Symbol>] how we should calculate the predicate value
        # @return [Integer] calculated predicate value for test case
        # @example
        #   build_value(0, :same) #=> 0
        #   build_value(0, [:add, 5]) #=> 5
        def build_value(predicate_value, value)
          case value
          when :same then
            predicate_value
          when Array then
            build_value_from_array(predicate_value, value)
          end
        end

        # Calculates predicate value for given test case
        # @param predicate_value [Integer] predicate value from schema
        # @param value [Array<Symbol>] how we should calculate the predicate value
        # @return [Integer] calculated predicate value for test case
        # @example
        #   build_value_from_array(0, [:add, 5]) #=> 5
        #   build_value_from_array(0, [:substract, 5]) #=> -5
        def build_value_from_array(predicate_value, value)
          case value.first
          when :substract then
            predicate_value - value.last
          when :add then
            predicate_value + value.last
          end
        end

        # Builds predicate test case
        # @param predicate_value [Integer] predicate value from schema
        # @param types [Hash] predicate test cases
        # @return [Hash] predicate test cases on which validation should succeed and error
        # @example
        #   build_type(
        #     0,
        #     {
        #       :success => { :int? => [:same], :gteq? => [:same, [:add, 5]] },
        #       :error => { :gteq? => [[:substract, 5]] }
        #     }
        #   ) #=>
        #     {
        #       :int? => { :success => [0] },
        #       :gteq? => { :success => [0, 5], :error => [-5] }
        #     }
        def build_type(predicate_value, types)
          types.each_with_object({}) do |(type, options), hash|
            options.each do |key, values|
              hash[key] ||= {}
              hash[key][type] ||= []
              values.each do |value|
                hash[key][type] << build_value(predicate_value, value)
              end
            end
          end
        end
      end
    end
  end
end
