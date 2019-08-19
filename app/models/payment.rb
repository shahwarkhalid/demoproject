# frozen_string_literal: true

class Payment < ApplicationRecord
  has_many :comments, as: :commentable
  belongs_to :project
  belongs_to :creator, class_name: 'User'
  paginates_per 5

  validates_presence_of :payment_type
  validates_presence_of :title
  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than: 0, less_than: 10_001 }

  def self.get_payments(project)
    payments = project.payments.order(:created_at)
  end

  def self.set_amount(payment)
    budget = payment.project.budget
    budget += payment.amount
    payment.project.update(budget: budget)
  end

  def self.revert_amount(payment)
    budget = payment.project.budget
    budget -= payment.amount
    payment.project.update(budget: budget)
  end
end
