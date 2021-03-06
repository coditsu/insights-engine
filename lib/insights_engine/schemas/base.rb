# frozen_string_literal: true

module InsightsEngine
  # Namespace for internal schemas for ensuring data integrity
  module Schemas
    # Base schema from which all other should inherit
    # By default Dry schemas don't raise errors, but we won't to fail it
    #   anything goes wrong so we won't get semi-valid data out of this gem
    #   that's why the #call method is patched
    # @note With schemas we don't inherit directly.
    #   Instead we use following syntax:
    #   CustomBaseBasedSchema = Dry::Validation.Schema(Base) do
    #     # Schema definition goes here
    #   end
    class Base < Dry::Validation::Contract
      config.messages.load_paths << File.join(
        InsightsEngine.gem_root,
        'config',
        'locales',
        I18n.locale.to_s,
        'dry-validations.yml'
      )

      # @param args [Array] all the arguments that the
      #   Dry::Validation::Schema#call method accepts
      # @raise [InsightsEngine::Errors::InvalidAttributes] raised when our
      #   incoming data does not fit into our schema
      def call(*args)
        result = super
        return result if result.success?

        raise Errors::InvalidAttributes, "#{result.errors.to_h}: #{args}"
      end
    end
  end
end
