module SchemasSpec
  class Predicate
    class Fixnum
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
        def fetch_value(key, predicates)
          match = predicates.select { |p| p.to_s.include?(key.to_s) }
          return if match.empty?
          # [{:gteq?=>10}] => 10
          match.first.to_a.flatten.last
        end

        def build_value(predicate_value, value)
          case value
          when :same then
            predicate_value
          when Array then
            build_value_from_array(predicate_value, value)
          end
        end

        def build_value_from_array(predicate_value, value)
          case value.first
          when :substract then
            predicate_value - value.last
          when :add then
            predicate_value + value.last
          end
        end

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

        def build!(object, predicates)
          object.merge!(
            CONFIG.each_with_object({}) do |(predicate, types), hash|
              value = fetch_value(predicate, predicates)
              next unless value
              hash.merge!(build_type(value, types))
            end
          )
        end
      end
    end
  end
end
