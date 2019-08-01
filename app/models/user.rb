# frozen_string_literal: true

class User < ApplicationRecord
  paginates_per 5

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates_presence_of :name, on: :create
  validates_presence_of :age, on: :update
  validates_presence_of :address, on: :update
  validates_numericality_of :age, greater_than: 0, only_integer: true, on: :update

  has_many :employees_projects, foreign_key: 'employee_id'
  has_many :projects, :through => :employees_projects

  def admin?
    role == 'admin'
  end

  def user?
    role == 'user'
  end

  def manager?
    role == 'manager'
  end

  def self.search_users(term, role, current_user)
    users = self.all
    users = users.where(role: role) if !role.empty?
    users = users.where('name LIKE ? OR email LIKE ?', "%#{term}%", "%#{term}%") if !term.empty?
    users = users.where.not(id: current_user.id)
    users
  end

  def active_for_authentication?
    super && status?
  end
end
