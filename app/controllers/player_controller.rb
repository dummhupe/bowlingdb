class PlayerController < ReportController
  def show
    @games = {}
    @games[:top] = Game.joins(:match_day).where(:player_id => @player_restrictions, 'match_days.location_id' => @location_restrictions, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day).order('points DESC, match_days.match_day DESC').first(5)
    @games[:low] = Game.joins(:match_day).where(:player_id => @player_restrictions, 'match_days.location_id' => @location_restrictions, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day).order('points, match_days.match_day DESC').first(5)
    @games[:max] = get_max_scores
    @games[:min] = get_min_scores
    @games[:avg] = get_avg_scores
    @games[:chart] = get_chart_data
  end

  def get_max_scores
    data = {}
    data[:points] = get_score('points')
    data[:cleared_frames] = get_score('cleared_frames')
    data[:strikes] = get_score('strikes')
    data[:spares] = get_score('spares')
    data[:splits] = get_score('splits', true)
    data[:cleared_splits] = get_score('cleared_splits')
    data[:fouls] = get_score('fouls', true)
    return data
  end

  def get_min_scores
    data = {}
    data[:points] = get_score('points', true)
    data[:cleared_frames] = get_score('cleared_frames', true)
    data[:strikes] = get_score('strikes', true)
    data[:spares] = get_score('spares', true)
    data[:splits] = get_score('splits', false)
    data[:cleared_splits] = get_score('cleared_splits', true)
    data[:fouls] = get_score('fouls', false)
    return data
  end

  def get_avg_scores
    data = Game.connection.select_one(
      'SELECT player_id, COUNT(*) AS game_count, AVG(points) AS points, AVG(cleared_frames) AS cleared_frames, AVG(strikes) AS strikes, AVG(spares) AS spares, AVG(splits) AS splits, AVG(cleared_splits) AS cleared_splits, AVG(fouls) AS fouls
      FROM games INNER JOIN match_days ON games.match_day_id = match_days.id
      WHERE ' + get_restrictions_as_sql + '
      ORDER BY points DESC, game_count DESC, strikes DESC, spares DESC, cleared_splits DESC, cleared_frames DESC, splits ASC'
    )
    g = UntypedGame.new
    g.player = Player.find(data['player_id'])
    g.number = data['game_count']
    g.points = data['points']
    g.cleared_frames = data['cleared_frames']
    g.strikes = data['strikes']
    g.spares = data['spares']
    g.splits = data['splits']
    g.cleared_splits = data['cleared_splits']
    g.fouls = data['fouls']

    return g
  end

  def get_chart_data
    data = {}
    data[:chart] = {}
    data[:regression] = {}
    @regression_data = {}
    data[:max_series_points] = 0
    @nMaxSeriesPoints = 0

    player_id = @player_restrictions.first

    data[:chart] = Game.joins(:match_day).select('match_day_id, COUNT(points) AS game_count, AVG(points) AS points').where(:player_id => player_id, 'match_days.location_id' => @location_restrictions, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day).group('match_day_id').order('match_days.match_day')
    if data[:chart].length > data[:max_series_points]
      data[:max_series_points] = data[:chart].length
    end
    if @regression and data[:chart] and data[:chart].to_a.size > 5
      data[:regression] = regression(data[:chart].map {|g| g.match_day.match_day.to_datetime.to_i }, data[:chart].map {|g| g.points })
    end

    return data
  end

  protected
  def location_key
    :player_location
  end
  def category_key
    :player_category
  end
  def player_key
    :id
  end
  def date_mode_key
    :player_date_mode
  end
  def date_from_key
    :player_date_from
  end
  def date_to_key
    :player_date_to
  end
  def regression_key
    :player_regression
  end
  def player_default
    params[:id]
  end
  def date_mode_default
    'none'
  end
  def regression_default
    true
  end

  private
  def get_score(type, low = false)
    return Game.joins(:match_day).where(:player_id => @player_restrictions, 'match_days.location_id' => @location_restrictions, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day).order(type + ' ' + (low ? '' : 'DESC') + ', match_days.match_day DESC').first
  end
end
