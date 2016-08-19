# frozen_string_literal: true
module Ninshiki
  module Schemas
    # Schema used to describe authors
    # This is populated based on the git details and git provides author name and his email
    # This schema should be used to validate all the authors of all the things
    Author = Dry::Validation.Schema(Base) do
      required(:name).filled(:str?)
      required(:email).filled(:str?)
    end
  end
end
