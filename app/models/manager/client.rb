# frozen_string_literal: true

class Manager::Client < ApplicationRecord
  validates_presence_of :first_name, on: :create
  validates_presence_of :email, on: :create
  validates_presence_of :phone, on: :create
end
