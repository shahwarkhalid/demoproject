# frozen_string_literal: true

class Client < ApplicationRecord
  has_many :projects

  validates_presence_of :first_name, on: :create
  validates_presence_of :email, on: :create
  validates_presence_of :phone_no, on: :create
  paginates_per 5

  def self.search_clients(params)
    clients = all
    clients = clients.where('first_name LIKE ? OR email LIKE ?', "%#{params[:name]}%", "%#{params[:name]}%") if params.key?(:name) && !params[:name].empty?
    clients.order(:created_at)
  end
end
