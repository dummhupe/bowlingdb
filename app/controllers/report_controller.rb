class ReportController < ApplicationController
  before_filter do |controller|
    if params[:reset]
      params[:location] = params[:category] = params[:player] = params[:date_mode] = params[:regression] = params[:date_from] = params[:date_to] = nil
      session[:location] = session[:category] = session[:player] = session[:date_mode] = session[:regression] = session[:date_from] = session[:date_to] = nil
    end

    if params.include? :regression
      @regression = params[:regression] == "true"
    elsif session.include? :regression
      @regression = session[:regression]
    else
      @regression = false
    end



    @location_restrictions = params[:location] || session[:location] || Location.select(:id).uniq.map { |l| l.id }
    @category_restrictions = params[:category] || session[:category] || Category.select(:id).uniq.map { |c| c.id }
    @player_restrictions = params[:player] || session[:player] || Player.select(:id).uniq.map { |p| p.id }
    if not @player_restrictions.kind_of? Array
      @player_restrictions = [@player_restrictions]
    end

    @date_mode = params[:date_mode] || session[:date_mode] || 'halfyear'
    date_from  = params[:date_from] || session[:date_from] || nil
    date_to    = params[:date_to]   || session[:date_to]   || nil
    case @date_mode
    when 'none' then
      @date_from_restriction = MatchDay.order(:match_day).first
      @date_to_restriction = MatchDay.order('match_day DESC').first

    when 'year' then
      @date_from_restriction = MatchDay.where('match_day <= ?', Date.today.prev_year.strftime('%Y-%m-%d')).order('match_day DESC').first
      @date_to_restriction = MatchDay.order('match_day DESC').first

    when 'halfyear' then
      @date_from_restriction = MatchDay.where('match_day <= ?', Date.today.prev_month(6).strftime('%Y-%m-%d')).order('match_day DESC').first
      @date_to_restriction = MatchDay.order('match_day DESC').first

    when 'quarter' then
      @date_from_restriction = MatchDay.where('match_day <= ?', Date.today.prev_month(3).strftime('%Y-%m-%d')).order('match_day DESC').first
      @date_to_restriction = MatchDay.order('match_day DESC').first

    when 'exact' then
      @date_from_restriction = MatchDay.find(date_from)
      @date_to_restriction = MatchDay.find(date_to)

    end

    session[:location]   = @location_restrictions
    session[:category]   = @category_restrictions
    session[:player]     = @player_restrictions
    session[:date_mode]  = @date_mode
    session[:date_from]  = date_from
    session[:date_to]    = date_to
    session[:regression] = @regression

    @graphics_height = session[:graphics_height] || get_default_graphics_height
  end

  def regression x, y
    degree = session[:polynom_degree] || get_default_polynom_degree
    resolution = session[:polynom_resolution] || get_default_polynom_resolution

    x_data = x.map {|xi| (0..degree).map{|pow| (xi**pow) }}
    mx = Matrix[*x_data]
    my = Matrix.column_vector y

    coefficients = ((mx.t * mx).inv * mx.t * my).transpose.to_a[0].reverse

    result = []
    distance = (x.last - x.first) / resolution.to_f
    current_x = x.first
    resolution.times do |i|
      result << [current_x, evaluate_polynom(current_x, coefficients)]
      current_x += distance
    end
    result
  end

  def evaluate_polynom x, coefficients
    degree = coefficients.size - 1

    result = 0
    (0..degree).map do |pow|
      result += coefficients.reverse[pow] * x**pow
    end
    result
  end
end
