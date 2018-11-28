QueryRoot = GraphQL::ObjectType.define do
  name "QueryRoot"

  field :me, ApiUserType do
    resolve ->(obj, args, ctx) { ctx[:api_user] if ctx[:api_user].logged_in? }
  end

  field :organization do
    type OrganizationType
    argument :id, !types.ID, "Filter by organization ID"
    resolve ->(obj, args, ctx) {
      ctx[:api_user].scope(klass: Organization,
                           action: :show,
                           ids: args[:id])
    }
  end
end