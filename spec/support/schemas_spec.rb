# frozen_string_literal: true

# Set of helpers to test Dry::Validation::Schema
module SchemasSpec; end

RSpec.shared_context 'when it is a schemas spec with scope' do |scope, name, *predicates|
  include_context 'when it is a schemas spec loop', scope, name, predicates
end

RSpec.shared_context 'when it is a schemas spec loop' do |scope, name, predicates|
  context name.to_s do
    predicates.each do |predicate|
      include_context(
        'schemas spec validation',
        SchemasSpec::Options.prepare(name, predicates, predicate, scope)
      )
    end
  end
end

RSpec.shared_context 'when it is a schemas spec' do |name, *predicates|
  include_context 'when it is a schemas spec loop', nil, name, predicates
end

RSpec.shared_examples 'schemas spec nested' do |hash|
  hash.each do |scope, fields|
    fields.each do |name, predicates|
      it_behaves_like 'when it is a schemas spec', "#{scope}.#{name}", *predicates
    end
  end
end

RSpec.shared_examples 'schemas spec first' do |hash|
  hash.each do |scope, fields|
    fields.each do |name, predicates|
      it_behaves_like 'when it is a schemas spec with scope', scope, name, *predicates
    end
  end
end

RSpec.shared_examples 'schemas spec validation' do |options|
  predicates = SchemasSpec::Predicate.build(options[:predicates])
  if predicates.key?(options[:predicate])
    predicates[options[:predicate]].each do |key, values|
      values.each do |value|
        if key == :success
          it "#{options[:predicate]}(#{options[:predicate_value]}) #{value}" do
            expect do
              described_class.schema.call(
                SchemasSpec::Input.change(options.merge(input: input, value: value))
              )
            end.not_to raise_error
          end
        else
          it "#{options[:predicate]}(#{options[:predicate_value]}) #{value}" do
            expect do
              described_class.schema.call(
                SchemasSpec::Input.change(options.merge(input: input, value: value))
              )
            end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
          end
        end
      end
    end
  end
end
