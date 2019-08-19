# frozen_string_literal: true

class TimelogSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :start_time, :end_time, :hours, :created_at, :updated_at, :comments

  def comments
    ActiveModel::SerializableResource.new(object.comments, each_serializer: CommentSerializer)
  end
end
