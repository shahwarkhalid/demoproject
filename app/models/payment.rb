# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :project
  belongs_to :creator, class_name: 'User'
end
