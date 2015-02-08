class Player < ActiveRecord::Base
  attr_accessible :firstname, :lastname
  validates :firstname, :presence => true

  has_many :game, :inverse_of => :player, :dependent => :destroy
  
  def self.players_for_selection
    Player.all(:order => ['lastname', 'firstname']).map { |p|
      [p.full_name, p.id]
    }
  end

  def full_name
    firstname + " " + lastname
  end

  def points(match_day)
    result = 0
    games(match_day).each do |g|
      result += g.points
    end
    return result
  end

  def games(match_day)
    result = []
    match_day.game.each do |g|
      result << g if g.player == self
    end

    return result
  end

  def games_share(match_day)
    game_count = {}
    match_day.game.each do |g|
      game_count[g.player] = 0 unless game_count[g.player]
      game_count[g.player] += 1
    end

    (games(match_day).count * 100.0 / game_count.values.max).floor
  end

  def strikes(match_day)
    sum_state(match_day, "strikes")
  end

  def strikes_share(match_day)
    possible_strikes = frames_count(match_day)
    (strikes(match_day) * 100.0 / possible_strikes).floor
  end

  def spares(match_day)
    sum_state(match_day, "spares")
  end

  def spares_share(match_day)
    # in every frame only one spare is possible
    possible_spares = games(match_day).count * 10
    (spares(match_day) * 100.0 / possible_spares).floor
  end

  def splits(match_day)
    sum_state(match_day, "splits")
  end

  def splits_share(match_day)
    # in tenth frame only two splits can be thrown
    possible_splits = frames_count(match_day) - games(match_day).count
    (splits(match_day) * 100.0 / possible_splits).floor
  end

  def cleared_splits(match_day)
    sum_state(match_day, "cleared_splits")
  end

  def cleared_splits_share(match_day)
    (cleared_splits(match_day) * 100.0 / splits(match_day)).floor
  end

  def gutter(match_day)
    result = 0
    games(match_day).each do |g|
      1..10.times do |i|
        result += 1 if g.send("frame%02d_result1" % (i+1).to_s) == 0
        result += 1 if g.send("frame%02d_result2" % (i+1).to_s) == 0
      end
      result += 1 if g.frame10_result3 == 0
    end
    return result
  end

  def gutter_share(match_day)
    (gutter(match_day) * 100.0  / throws_count(match_day)).floor
  end

  def fouls(match_day)
    sum_state(match_day, "fouls")
  end

  def fouls_share(match_day)
    (fouls(match_day) * 100.0 / throws_count(match_day)).floor
  end

  def high_game(match_day)
    result = 0
    games(match_day).each do |g|
      result = g.points if g.points > result
    end
    return result
  end

  def low_game(match_day)
    result = 300
    games(match_day).each do |g|
      result = g.points if g.points < result
    end
    return result
  end

  private
  def sum_state(match_day, cstic)
    result = 0
    games(match_day).each do |g|
      result += g.send(cstic)
    end
    return result
  end

  def throws_count(match_day)
    throws = 0
    games(match_day).each do |g|
      1..10.times do |i|
        throws += 1 if g.send("frame%02d_result1" % (i+1).to_s)
	throws += 1 if g.send("frame%02d_result2" % (i+1).to_s)
      end
      throws += 1 if g.frame10_result3
    end
    return throws
  end

  def frames_count(match_day)
    result = games(match_day).count * 10
    # add one for each tenth frame
    result += games(match_day).count
    # add one for each tenth frame with three throws
    games(match_day).each do |g|
      result += 1 if g.frame10_result3
    end
    return result
  end
end
