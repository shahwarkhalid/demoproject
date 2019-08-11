# frozen_string_literal: true

class Client < ApplicationRecord
  has_many :projects

  validates_presence_of :first_name, on: :create
  validates_presence_of :email, on: :create
  validates_presence_of :phone_no, on: :create
  paginates_per 5

  def self.search_clients(term)
    clients = all
    clients = clients.where('first_name LIKE ? OR email LIKE ?', "%#{term}%", "%#{term}%") unless term.empty?
    clients
  end
end
