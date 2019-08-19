class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :payment_type, :amount, :title, :comments

  def comments
    ActiveModel::SerializableResource.new(object.comments,  each_serializer: CommentSerializer)
  end
end
