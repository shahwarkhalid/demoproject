# frozen_string_literal: true

class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :title, :description
end
