# frozen_string_literal: true

class Payment < ApplicationRecord
  validates_presence_of :payment_type
  validates_presence_of :title
  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than: 0, less_than: 10_001 }

  belongs_to :project
  belongs_to :creator, class_name: 'User'
  paginates_per 5
end
