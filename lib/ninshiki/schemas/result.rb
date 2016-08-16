# frozen_string_literal: true
module Ninshiki
  # Namespace containing schemas that expose data outside of this gem
  module Schemas
    #  Result schema used to validate everything that gets out of this gem
    Result = Dry::Validation.Schema(Base) do
      required(:repository_authors).each(RepositoryAuthor)
    end
  end
end
