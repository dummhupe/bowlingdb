require 'will_paginate/array'

class AveragesController < ReportController
  WillPaginate.per_page = 20

  def show
    @games = []
    Game.connection.select_all(
      'SELECT player_id, COUNT(*) AS game_count, AVG(points) AS points, AVG(cleared_frames) AS cleared_frames, AVG(strikes) AS strikes, AVG(spares) AS spares, AVG(splits) AS splits, AVG(cleared_splits) AS cleared_splits, AVG(fouls) AS fouls
      FROM games INNER JOIN match_days ON games.match_day_id = match_days.id
      WHERE ' + get_restrictions_as_sql + '
      GROUP BY player_id
       ORDER BY points DESC, game_count DESC, strikes DESC, spares DESC, cleared_splits DESC, cleared_frames DESC, splits ASC'
    ).each do |row|
      game = UntypedGame.new
      game.player = Player.find(row['player_id'])
      game.number = row['game_count']
      game.points = row['points']
      game.cleared_frames = row['cleared_frames']
      game.strikes = row['strikes']
      game.spares = row['spares']
      game.splits = row['splits']
      game.cleared_splits = row['cleared_splits']
      game.fouls = row['fouls']
      @games << game
    end
    @games = sort(@games).paginate(:page => params[:page])
  end
end
