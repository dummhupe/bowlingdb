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
      game.points = '%.2f' % row['points'].round(2)
      game.cleared_frames = '%.2f' % row['cleared_frames'].round(2)
      game.strikes = '%.2f' % row['strikes'].round(2)
      game.spares = '%.2f' % row['spares'].round(2)
      game.splits = '%.2f' % row['splits'].round(2)
      game.cleared_splits = '%.2f' % row['cleared_splits'].round(2)
      game.fouls = '%.2f' % row['fouls'].round(2)
      @games << game
    end
    @games = @games.paginate(:page => params[:page])
  end
end
