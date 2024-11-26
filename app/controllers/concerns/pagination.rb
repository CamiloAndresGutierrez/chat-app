# frozen_string_literal: true

# Pagination module
module Pagination
  extend ActiveSupport::Concern

  DEFAULT_PER_PAGE = 25
  DEFAULT_PAGE = 1

  def page_no
    params[:page]&.to_i || DEFAULT_PAGE
  end

  def per_page
    params[:per_page]&.to_i || DEFAULT_PER_PAGE
  end

  def paginate_offset
    (page_no - 1) * per_page
  end

  def paginate
    ->(it) { it.limit(per_page).offset(paginate_offset) }
  end
end
