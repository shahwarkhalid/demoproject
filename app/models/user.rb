# frozen_string_literal: true

class User < ApplicationRecord
  paginates_per 5

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :employees_projects, foreign_key: 'employee_id'
  has_many :projects, through: :employees_projects
  has_many :managed_projects, class_name: 'Project', foreign_key: 'manager_id'
  has_many :created_projects, class_name: 'Project', foreign_key: 'creator_id'
  has_many :payments, foreign_key: 'creator_id'
  has_many :timelogs, foreign_key: 'employee_id'
  has_many :created_comments, class_name: 'Comment', foreign_key: 'creator_id'
  has_many :created_timelogs, class_name: 'Timelog', foreign_key: 'creator_id'
  has_many :attachments, foreign_key: 'creator_id'

  validates_presence_of :name, on: :create
  validates_presence_of :age, on: :update
  validates_presence_of :address, on: :update
  validates_numericality_of :age, greater_than: 0, only_integer: true, on: :update

  mount_uploader :image, ImageUploader

  attr_accessor :shared_secret
  attr_accessor :token_expires

  def admin?
    role == 'admin'
  end

  def user?
    role == 'user'
  end

  def manager?
    role == 'manager'
  end

  def self.search_users(params, current_user)
    users = all
    users = users.where(role: params[:role]) if params.key?(:role) && !params[:role].empty?
    users = users.where('name LIKE ? OR email LIKE ?', "%#{params[:name]}%", "%#{params[:name]}%") if params.key?(:name) && !params[:name].empty?
    users = users.where.not(id: current_user.id)
    users.order(:created_at)
  end

  def self.domains_emails(domains)
    emails = []
    domains.each do |domain|
      emails += User.where('email like ?', "%#{domain}%").where(role: 'user')
    end
    emails
  end

  def self.authenticate(password)
    # user = User.find_by_name(name)

    if user.find_by_password(password) # match_password(password)
      true
    else
      false
    end
  end

  def active_for_authentication?
    super && status?
  end
end
