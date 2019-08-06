# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :creator, class_name: 'User'

  validates_presence_of :text
end
