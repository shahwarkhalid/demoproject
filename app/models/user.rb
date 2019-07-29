# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates_presence_of :name, on: :create
  validates_presence_of :age, on: :update
  validates_presence_of :address, on: :update
  validates_numericality_of :age, greater_than: 0, only_integer: true, on: :update

  def active_for_authentication?
    super && status?
  end
  paginates_per 5
end
