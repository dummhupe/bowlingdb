class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  def set_locale
    I18n.locale = :de
  end

  def get_default_graphics_height
    400
  end

  def get_default_polynom_degree
    4
  end

  def get_default_polynom_resolution
    100
  end
end
