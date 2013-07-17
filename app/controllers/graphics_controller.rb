class GraphicsController < ReportController

  default_polynom_degree = 4
  @default_resolution = 100

  def player_by_game
    @chart_type = 'scatter'
    @games = {}
    @player_restrictions.each do |player_id|
      @games[player_id] = Game.joins(:match_day).where(:player_id => player_id, 'match_days.location_id' => @location_restrictions, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day).order('match_days.match_day').map { |g| [g.match_day.match_day.to_time.to_i, g.points] }
    end

    if @player_restrictions.size == 1
      scores = Game.joins(:match_day).select('match_day_id, COUNT(points) AS game_count, AVG(points) AS points').where(:player_id => @player_restrictions.first, 'match_days.location_id' => @location_restrictions, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day).group('match_day_id').order('match_days.match_day').map { |g| [MatchDay.find(g.match_day_id).match_day.to_time.to_i, g.points] }
      @regression = regression(scores.map {|s| s[0] }, scores.map {|s| s[1] })
    end

    render :player_chart
  end

  def player_by_avg_match
    @chart_type = 'line'
    @games = {}
    @player_restrictions.each do |player_id|
    @games[player_id] = Game.joins(:match_day).select('match_day_id, COUNT(points) AS game_count, AVG(points) AS points').where(:player_id => player_id, 'match_days.location_id' => @location_restrictions, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day).group('match_day_id').order('match_days.match_day').map { |g| [MatchDay.find(g.match_day_id).match_day.to_time.to_i, g.points] }
    end       

    if @player_restrictions.size == 1
      scores = @games[@player_restrictions.first]
      @regression = regression(scores.map {|s| s[0] }, scores.map {|s| s[1] })
    end

    render :player_chart
  end

  def player_by_location
    @chart_type = 'line'

    if @player_restrictions.kind_of? Array
      @player_restrictions = @player_restrictions.first
    end

    @games = {}
    @location_restrictions.each do |location_id|
      @games[location_id] = Game.joins(:match_day).select('match_day_id, COUNT(points) AS game_count, AVG(points) AS points').where(:player_id => @player_restrictions, 'match_days.location_id' => location_id, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day).group('match_day_id').order('match_days.match_day').map { |g| g.points }
    end

    if @location_restrictions.size == 1
      scores = @games[@location_restrictions.first]
      @regression = regression((0..(scores.size-1)).map{|i| i}, scores)
    end

    render :location_chart
  end
end
