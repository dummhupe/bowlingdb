class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  helper_method :sort_column, :sort_direction

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

  private

  def sort(games)
    games.sort_by{ |g|
      if Game.column_names.include?(params[:sort])
        # with manual sort always also sort by date if possible
	begin
	  [sort_direction * g.send(params[:sort]), sort_direction * g.match_day.match_day.to_time.to_i]
	rescue NoMethodError
	  [sort_direction * g.send(params[:sort])]
	end
      else
        [-g.points, -g.strikes, -g.spares, -g.cleared_splits, -g.cleared_frames, g.splits]
      end
    }
  end

  def sort_column
    Game.column_names.include?(params[:sort]) ? params[:sort] : ""
  end

  def sort_direction
    case params[:direction]
    when 'asc' then 1
    when 'desc' then -1
    else 1
    end
  end
end
