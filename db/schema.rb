# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_190_807_071_017) do
  create_table 'attachments', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'name'
    t.string 'attachment'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'project_id'
    t.bigint 'creator_id'
    t.index ['creator_id'], name: 'index_attachments_on_creator_id'
    t.index ['project_id'], name: 'index_attachments_on_project_id'
  end

  create_table 'clients', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'first_name'
    t.string 'last_name'
    t.string 'phone_no'
    t.string 'email'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'comments', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'text'
    t.integer 'commentable_id'
    t.string 'commentable_type'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'creator_id'
    t.index ['creator_id'], name: 'index_comments_on_creator_id'
  end

  create_table 'employees_projects', id: false, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.bigint 'employee_id'
    t.bigint 'project_id'
    t.index ['employee_id'], name: 'index_employees_projects_on_employee_id'
    t.index ['project_id'], name: 'index_employees_projects_on_project_id'
  end

  create_table 'payments', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'payment_type'
    t.decimal 'amount', precision: 5, scale: 2
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'title'
    t.bigint 'project_id'
    t.bigint 'creator_id'
    t.index ['creator_id'], name: 'index_payments_on_creator_id'
    t.index ['project_id'], name: 'index_payments_on_project_id'
  end

  create_table 'projects', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'title'
    t.text 'description'
    t.boolean 'status'
    t.integer 'total_hours'
    t.integer 'hours_worked'
    t.decimal 'budget', precision: 5, scale: 2
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'client_id'
    t.bigint 'manager_id'
    t.bigint 'creator_id'
    t.index ['client_id'], name: 'index_projects_on_client_id'
    t.index ['creator_id'], name: 'index_projects_on_creator_id'
    t.index ['manager_id'], name: 'index_projects_on_manager_id'
  end

  create_table 'roles', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'timelogs', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'title'
    t.text 'description'
    t.datetime 'start_time'
    t.datetime 'end_time'
    t.integer 'hours'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'employee_id'
    t.bigint 'project_id'
    t.bigint 'creator_id'
    t.index ['creator_id'], name: 'index_timelogs_on_creator_id'
    t.index ['employee_id'], name: 'index_timelogs_on_employee_id'
    t.index ['project_id'], name: 'index_timelogs_on_project_id'
  end

  create_table 'users', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'email', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'name'
    t.string 'role'
    t.boolean 'status'
    t.integer 'age'
    t.string 'address'
    t.string 'image'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'attachments', 'projects'
  add_foreign_key 'payments', 'projects'
  add_foreign_key 'projects', 'clients'
end
