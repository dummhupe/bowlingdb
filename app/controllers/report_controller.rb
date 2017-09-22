class ReportController < ApplicationController
  before_filter do |controller|
    if params[:reset]
      params[player_key] = params[location_key] = params[category_key] = params[date_mode_key] = params[:regression] = params[date_from_key] = params[date_to_key] = nil
      session[player_key] = session[location_key] = session[category_key] = session[player_key] = session[date_mode_key] = session[:regression] = session[date_from_key] = session[date_to_key] = nil
    end

    if params.include? regression_key
      @regression = params[regression_key] == "true"
    elsif session.include? regression_key
      @regression = session[regression_key]
    else
      @regression = regression_default
    end

    @location_restrictions = params[location_key] || session[location_key] || location_default
    @location_restrictions = location_default if @location_restrictions.empty?
    @category_restrictions = params[category_key] || session[category_key] || category_default
    @category_restrictions = category_default if @category_restrictions.empty?
    @player_restrictions = params[player_key] || session[player_key] || player_default
    @player_restrictions = player_default if @player_restrictions.empty?
    if not @player_restrictions.kind_of? Array
      @player_restrictions = [@player_restrictions]
    end

    @date_mode = params[date_mode_key] || session[date_mode_key] || date_mode_default
    date_from  = params[date_from_key] || session[date_from_key] || date_from_default
    date_to    = params[date_to_key]   || session[date_to_key]   || date_to_default
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

    session[location_key]   = @location_restrictions
    session[category_key]   = @category_restrictions
    session[player_key]     = @player_restrictions
    session[date_mode_key]  = @date_mode
    session[date_from_key]  = date_from
    session[date_to_key]    = date_to
    session[regression_key] = @regression

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

  def get_restrictions_as_sql
    'player_id IN (' + quote(@player_restrictions).join(',') + ')
     AND location_id IN (' + quote(@location_restrictions).join(',') + ')
     AND category_id IN (' + quote(@category_restrictions).join(',') + ')
     AND match_days.match_day >= \'' + @date_from_restriction.match_day.to_s + '\'
     AND match_days.match_day <= \'' + @date_to_restriction.match_day.to_s + '\''
  end

  def quote(array)
    array.map do |i|
      MatchDay.connection.quote(i)
    end
  end

  protected
  def location_key
    :location
  end
  def category_key
    :category
  end
  def player_key
    :player
  end
  def date_mode_key
    :date_mode
  end
  def date_from_key
    :date_from
  end
  def date_to_key
    :date_to
  end
  def regression_key
    :regression
  end
  def location_default
    Location.select(:id).uniq.map { |l| l.id }
  end
  def category_default
    Category.select(:id).uniq.map { |c| c.id }
  end
  def player_default
    Player.select(:id).uniq.map { |p| p.id }
  end
  def date_mode_default
    'halfyear'
  end
  def date_from_default
    nil
  end
  def date_to_default
    nil
  end
  def regression_default
    false
  end
end
