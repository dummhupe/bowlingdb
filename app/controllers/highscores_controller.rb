require 'will_paginate/array'

class HighscoresController < ReportController
  WillPaginate.per_page = 20

  def by_player
    @games = []
    Game.joins(:match_day).select('player_id, MAX(points) AS points').where(:player_id => @player_restrictions, 'match_days.location_id' => @location_restrictions, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day).group('player_id').each do |row|
      @games << Game.joins(:match_day).where(:player_id => row.player_id, :points => row.points).order('match_days.match_day DESC').first
    end
    @games = @games.sort_by{ |g| [-g.points, -g.strikes, -g.spares, -g.cleared_splits, -g.cleared_frames, g.splits] }.paginate(:page => params[:page])
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
    @games = @games.sort_by{ |g| [-g.points, -g.strikes, -g.spares, -g.cleared_splits, -g.cleared_frames, g.splits] }.paginate(:page => params[:page])
    render :results
  end

  def by_games
    @games = Game.joins(:match_day).where(:player_id => @player_restrictions, 'match_days.location_id' => @location_restrictions, 'match_days.category_id' => @category_restrictions).where('match_days.match_day >= ? AND match_days.match_day <= ?', @date_from_restriction.match_day, @date_to_restriction.match_day)
    @games = @games.sort_by{ |g| [-g.points, -g.strikes, -g.spares, -g.cleared_splits, -g.cleared_frames, g.splits] }.paginate(:page => params[:page])
    render :results
  end

  def by_avg_match_day
    @games = []
    Game.connection.select_all(
      'SELECT match_day_id, player_id, COUNT(*) AS game_count, AVG(points) AS points, AVG(cleared_frames) AS cleared_frames, AVG(strikes) AS strikes, AVG(spares) AS spares, AVG(splits) AS splits, AVG(cleared_splits) AS cleared_splits, AVG(fouls) AS fouls
      FROM games INNER JOIN match_days ON games.match_day_id = match_days.id
      WHERE ' + get_restrictions_as_sql + '
      GROUP BY match_day_id, player_id
      ORDER BY points DESC, strikes DESC, spares DESC, cleared_splits DESC, cleared_frames DESC, splits ASC'
    ).each do |row|
      game = UntypedGame.new
      game.number = row['game_count']
      game.match_day = MatchDay.find(row['match_day_id'])
      game.player = Player.find(row['player_id'])
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
    render :results
  end
end
