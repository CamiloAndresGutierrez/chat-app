class MessageSerializer < ActiveModel::Serializer
    attributes :content, :user
  end
  