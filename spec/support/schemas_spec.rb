# frozen_string_literal: true
RSpec.shared_context :schemas_spec_with_scope do |scope, name, *predicates|
  include_context :schemas_spec_loop, scope, name, predicates
end

RSpec.shared_examples :schemas_spec_loop do |scope, name, predicates|
  context name.to_s do
    predicates.each do |predicate|
      include_context(
        :schemas_spec_validation,
        SchemasSpec::Options.prepare(name, predicates, predicate, scope)
      )
    end
  end
end

RSpec.shared_context :schemas_spec do |name, *predicates|
  include_context :schemas_spec_loop, nil, name, predicates
end

RSpec.shared_examples :schemas_spec_nested do |hash|
  hash.each do |scope, fields|
    fields.each do |name, predicates|
      it_behaves_like :schemas_spec, "#{scope}.#{name}", *predicates
    end
  end
end

RSpec.shared_examples :schemas_spec_first do |hash|
  hash.each do |scope, fields|
    fields.each do |name, predicates|
      it_behaves_like :schemas_spec_with_scope, scope, name, *predicates
    end
  end
end

RSpec.shared_examples :schemas_spec_validation do |options|
  predicates = SchemasSpec::Predicate.build(options[:predicates])
  if predicates.key?(options[:predicate])
    predicates[options[:predicate]].each do |key, values|
      values.each do |value|
        it "#{options[:predicate]}(#{options[:predicate_value]}) #{value}" do
          if key == :success
            expect do
              described_class.schema.call(
                SchemasSpec::Input.change(
                  options.merge(input: input, value: value)
                )
              )
            end.not_to raise_error
          else
            expect do
              described_class.schema.call(
                SchemasSpec::Input.change(
                  options.merge(input: input, value: value)
                )
              )
            end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
          end
        end
      end
    end
  end
end
