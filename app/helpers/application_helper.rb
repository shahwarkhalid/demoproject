# frozen_string_literal: true

module ApplicationHelper
  def earning_month
    Date.today.strftime('%B %Y')
  end
end
