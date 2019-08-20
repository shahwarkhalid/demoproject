# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :creator, class_name: 'User'

  validates_presence_of :text

  def self.get_comments(commentable)
    commentable.comments.includes(:creator).order(updated_at: :desc)
  end
end
