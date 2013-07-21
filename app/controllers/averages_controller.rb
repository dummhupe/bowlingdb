require 'will_paginate/array'

class AveragesController < ReportController
  WillPaginate.per_page = 20

  def show
    @games = []
    Game.joins(:match_day).select('player_id, COUNT(*) AS game_count, AVG(points) AS points, AVG(cleared_frames) AS cleared_frames, AVG(strikes) AS strikes, AVG(spares) AS spares, AVG(splits) AS splits, AVG(cleared_splits) AS cleared_splits, AVG(fouls) AS fouls').where(:player_id => @player_restrictions, 'match_days.location_id' => @location_restrictions, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day).group(:player_id).each do |row|
      game = Game.new
      game.player_id = row.player_id
      game.number = row.game_count
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
  end
end
