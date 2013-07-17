class SettingsController < ApplicationController
  def edit
    @graphics_height = params[:graphics_height] || session[:graphics_height]
    if not @graphics_height or not @graphics_height.to_s.match(/^\d+$/) or @graphics_height.to_i < 100
      @graphics_heigt = get_default_graphics_height
    end

    @polynom_degree = params[:polynom_degree] || session[:polynom_degree]
    if not @polynom_degree or not @polynom_degree.to_s.match(/^\d+$/) or @polynom_degree.to_i < 1 or @polynom_degree.to_i > 9
      @polynom_degree = get_default_polynom_degree
    end

    @polynom_resolution = params[:polynom_resolution] || session[:polynom_resolution] || get_default_polynom_resolution
    if not @polynom_resolution or not @polynom_resolution.to_s.match(/^\d+$/) or @polynom_resolution.to_i < 20 or @polynom_resolution.to_i > 200
      @polynom_resolution = get_default_polynom_resolution
    end

    session[:graphics_height] = @graphics_height.to_i
    session[:polynom_degree] = @polynom_degree.to_i
    session[:polynom_resolution] = @polynom_resolution.to_i
  end
end
