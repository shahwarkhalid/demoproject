# frozen_string_literal: true

class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :comments

  def comments
    ActiveModel::SerializableResource.new(object.comments,  each_serializer: CommentSerializer)
  end
end
