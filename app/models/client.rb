class Client < ApplicationRecord
  validates_presence_of :first_name, on: :create
  validates_presence_of :email, on: :create
  validates_presence_of :phone_no, on: :create
  paginates_per 5

  has_many :projects

  def self.search_clients(term)
    clients = self.all
    clients = clients.where('first_name LIKE ? OR email LIKE ?', "%#{term}%", "%#{term}%") if !term.empty?
    clients
  end
end
