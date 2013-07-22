class GraphicsController < ReportController

  default_polynom_degree = 4
  @default_resolution = 100

  def player_by_game
    @chart_type = 'scatter'
    @games = {}
    @regression_data = {}
    @player_restrictions.each do |player_id|
      @games[player_id] = Game.joins(:match_day).where(:player_id => player_id, 'match_days.location_id' => @location_restrictions, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day).order('match_days.match_day')
      if @regression and @games[player_id]
        scores = Game.joins(:match_day).select('match_day_id, COUNT(points) AS game_count, AVG(points) AS points').where(:player_id => @player_restrictions.first, 'match_days.location_id' => @location_restrictions, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day).group('match_day_id').order('match_days.match_day').map { |g| [MatchDay.find(g.match_day_id).match_day.to_datetime.to_i, g.points] }
	@regression_data[player_id] = regression(scores.map {|s| s[0] }, scores.map {|s| s[1] })
      end
    end

    render :player_chart
  end

  def player_by_avg_match
    @chart_type = 'line'
    @games = {}
    @regression_data = {}
    @player_restrictions.each do |player_id|
      @games[player_id] = Game.joins(:match_day).select('match_day_id, COUNT(points) AS game_count, AVG(points) AS points').where(:player_id => player_id, 'match_days.location_id' => @location_restrictions, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day).group('match_day_id').order('match_days.match_day')
      if @regression and @games[player_id]
        scores = @games[player_id]
	@regression_data[player_id] = regression(scores.map {|g| g.match_day.match_day.to_datetime.to_i }, scores.map {|g| g.points })
      end
    end       

    render :player_chart
  end

  def player_by_location
    @chart_type = 'line'

    if @player_restrictions.kind_of? Array
      @player_restrictions = @player_restrictions.first
    end

    @games = {}
    @regression_data = {}
    @location_restrictions.each do |location_id|
      @games[location_id] = Game.joins(:match_day).select('match_day_id, COUNT(points) AS game_count, AVG(points) AS points').where(:player_id => @player_restrictions, 'match_days.location_id' => location_id, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day).group('match_day_id').order('match_days.match_day')
      if @regression and @games[location_id]
        scores = @games[location_id]
	@regression_data[location_id] = regression((0..(scores.to_a.size-1)).map{|i| i}, scores.map{|g| g.points})
      end
    end

    render :location_chart
  end
end
