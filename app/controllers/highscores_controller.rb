require 'will_paginate/array'

class HighscoresController < ReportController
  WillPaginate.per_page = 20

  def by_player
    @games = []
    Game.joins(:match_day).select('player_id, MAX(points) AS points').where(:player_id => @player_restrictions, 'match_days.location_id' => @location_restrictions, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day).group('player_id').each do |row|
      @games << Game.joins(:match_day).where(:player_id => row.player_id, :points => row.points).order('match_days.match_day DESC').first
    end
    @games = @games.sort { |a,b| b.points <=> a.points }.paginate(:page => params[:page])
    render :results
  end

  def by_match_day
    @games = []
    Game.joins(:match_day).select('match_day_id, player_id, COUNT(*) AS game_count, SUM(points) AS points, SUM(cleared_frames) AS cleared_frames, SUM(strikes) AS strikes, SUM(spares) AS spares, SUM(splits) AS splits, SUM(cleared_splits) AS cleared_splits, SUM(fouls) AS fouls').where(:player_id => @player_restrictions, 'match_days.location_id' => @location_restrictions, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day).group(:match_day_id, :player_id).each do |row|
      game = Game.new
      game.number = row.game_count
      game.match_day = MatchDay.find(row.match_day_id)
      game.player = Player.find(row.player_id)
      game.points = row.points
      game.cleared_frames = row.cleared_frames
      game.strikes = row.strikes
      game.spares = row.spares
      game.splits = row.splits
      game.cleared_splits = row.cleared_splits
      game.fouls = row.fouls
      @games << game
    end
    @games = @games.sort { |a,b| b.points <=> a.points }.paginate(:page => params[:page])
    render :results
  end

  def by_games
    @games = Game.joins(:match_day).where(:player_id => @player_restrictions, 'match_days.location_id' => @location_restrictions, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day).order('points DESC').paginate(:page => params[:page])
    render :results
  end
end
