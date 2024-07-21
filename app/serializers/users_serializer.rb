class UsersSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :name
end
