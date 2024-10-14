# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :active, :last_sign_in_at, :current_sign_in_at
end
