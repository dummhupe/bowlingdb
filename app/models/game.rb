class Game < ActiveRecord::Base
  attr_accessible :player, :number
  validates :player, :presence => true
  validates :number, :presence => true, :numericality => { :only_integer => true, :greather_than => 0 }
  attr_accessible :points, :cleared_frames, :strikes, :spares, :fouls, :splits, :cleared_splits

  attr_accessible :frame01_result1, :frame01_result2
  attr_accessible :frame01_state1,  :frame01_state2
  attr_accessible :frame02_result1, :frame02_result2
  attr_accessible :frame02_state1,  :frame02_state2
  attr_accessible :frame03_result1, :frame03_result2
  attr_accessible :frame03_state1,  :frame03_state2
  attr_accessible :frame04_result1, :frame04_result2
  attr_accessible :frame04_state1,  :frame04_state2
  attr_accessible :frame05_result1, :frame05_result2
  attr_accessible :frame05_state1,  :frame05_state2
  attr_accessible :frame06_result1, :frame06_result2
  attr_accessible :frame06_state1,  :frame06_state2
  attr_accessible :frame07_result1, :frame07_result2
  attr_accessible :frame07_state1,  :frame07_state2
  attr_accessible :frame08_result1, :frame08_result2
  attr_accessible :frame08_state1,  :frame08_state2
  attr_accessible :frame09_result1, :frame09_result2
  attr_accessible :frame09_state1,  :frame09_state2
  attr_accessible :frame10_result1, :frame10_result2, :frame10_result3
  attr_accessible :frame10_state1,  :frame10_state2,  :frame10_state3
  validates :frame01_result1, :numericality => { :only_integer => true, :less_than_or_equal_to => 10 }
  validates :frame01_result2, :numericality => { :only_integer => true, :less_than_or_equal_to => 10, :allow_nil => true }
  validates :frame02_result1, :numericality => { :only_integer => true, :less_than_or_equal_to => 10 }
  validates :frame02_result2, :numericality => { :only_integer => true, :less_than_or_equal_to => 10, :allow_nil => true }
  validates :frame03_result1, :numericality => { :only_integer => true, :less_than_or_equal_to => 10 }
  validates :frame03_result2, :numericality => { :only_integer => true, :less_than_or_equal_to => 10, :allow_nil => true }
  validates :frame04_result1, :numericality => { :only_integer => true, :less_than_or_equal_to => 10 }
  validates :frame04_result2, :numericality => { :only_integer => true, :less_than_or_equal_to => 10, :allow_nil => true }
  validates :frame05_result1, :numericality => { :only_integer => true, :less_than_or_equal_to => 10 }
  validates :frame05_result2, :numericality => { :only_integer => true, :less_than_or_equal_to => 10, :allow_nil => true }
  validates :frame06_result1, :numericality => { :only_integer => true, :less_than_or_equal_to => 10 }
  validates :frame06_result2, :numericality => { :only_integer => true, :less_than_or_equal_to => 10, :allow_nil => true }
  validates :frame07_result1, :numericality => { :only_integer => true, :less_than_or_equal_to => 10 }
  validates :frame07_result2, :numericality => { :only_integer => true, :less_than_or_equal_to => 10, :allow_nil => true }
  validates :frame08_result1, :numericality => { :only_integer => true, :less_than_or_equal_to => 10 }
  validates :frame08_result2, :numericality => { :only_integer => true, :less_than_or_equal_to => 10, :allow_nil => true }
  validates :frame09_result1, :numericality => { :only_integer => true, :less_than_or_equal_to => 10 }
  validates :frame09_result2, :numericality => { :only_integer => true, :less_than_or_equal_to => 10, :allow_nil => true }
  validates :frame10_result1, :numericality => { :only_integer => true, :less_than_or_equal_to => 10 }
  validates :frame10_result2, :numericality => { :only_integer => true, :less_than_or_equal_to => 10 }
  validates :frame10_result3, :numericality => { :only_integer => true, :less_than_or_equal_to => 10, :allow_nil => true }

  validates :frame01_state1, :inclusion => { :in => %w(N S F X) }
  validates :frame01_state2, :inclusion => { :in => [nil, 'N', 'F', '/'] }
  validates :frame02_state1, :inclusion => { :in => %w(N S F X) }
  validates :frame02_state2, :inclusion => { :in => [nil, 'N', 'F', '/'] }
  validates :frame03_state1, :inclusion => { :in => %w(N S F X) }
  validates :frame03_state2, :inclusion => { :in => [nil, 'N', 'F', '/'] }
  validates :frame04_state1, :inclusion => { :in => %w(N S F X) }
  validates :frame04_state2, :inclusion => { :in => [nil, 'N', 'F', '/'] }
  validates :frame05_state1, :inclusion => { :in => %w(N S F X) }
  validates :frame05_state2, :inclusion => { :in => [nil, 'N', 'F', '/'] }
  validates :frame06_state1, :inclusion => { :in => %w(N S F X) }
  validates :frame06_state2, :inclusion => { :in => [nil, 'N', 'F', '/'] }
  validates :frame07_state1, :inclusion => { :in => %w(N S F X) }
  validates :frame07_state2, :inclusion => { :in => [nil, 'N', 'F', '/'] }
  validates :frame08_state1, :inclusion => { :in => %w(N S F X) }
  validates :frame08_state2, :inclusion => { :in => [nil, 'N', 'F', '/'] }
  validates :frame09_state1, :inclusion => { :in => %w(N S F X) }
  validates :frame09_state2, :inclusion => { :in => [nil, 'N', 'F', '/'] }
  validates :frame10_state1, :inclusion => { :in => %w(N S F X) }
  validates :frame10_state2, :inclusion => { :in => %w(N S F / X) }
  validates :frame10_state3, :inclusion => { :in => [nil, 'N', 'F', 'S', '/', 'X'] }

  belongs_to :match_day, :inverse_of => :game
  belongs_to :player, :inverse_of => :game
  
  before_validation { |game|
    fill_points_and_states(game)
    fill_aggregations(game)
  }

  def self.numbers_for_selection(match)
    i = match.game.map(&:number).uniq.size + 1
    Array(1..i)
  end

  def self.states_for_throw1_selection
    %w{N S F X}.map { |s| [s] }
  end

  def self.states_for_throw2_selection
    %w{N F /}.map { |s| [s] }
  end

  def self.states_for_frame10_selection
    %w{N S F / X}.map { |s| [s] }
  end

  def points_up_to_frame(n)
    points = 0
    counter = [n, 9].min
    counter.times do |i|
      points += send("frame%02d_result1" % (i+1).to_s)
      if send("frame%02d_state1" % (i+1).to_s) == 'X'
        points += send("frame%02d_result1" % (i+2).to_s)
	if send("frame%02d_state1" % (i+2).to_s) == 'X'
	  if i+2 == 10 # add second throw of tenth frame
	    points += send("frame%02d_result2" % (i+2).to_s)
	  else
	    points += send("frame%02d_result1" % (i+3).to_s)
	  end
	else
	  points += send("frame%02d_result2" % (i+2).to_s)
	end
      elsif send("frame%02d_state2" % (i+1).to_s) == '/'
        points += send("frame%02d_result2" % (i+1).to_s)
	points += send("frame%02d_result1" % (i+2).to_s)
      else
        points += send("frame%02d_result2" % (i+1).to_s)
      end
    end
    if n > 9
      points += frame10_result1
      points += frame10_result2
      points += frame10_result3 if frame10_result3
    end

    return points
  end

  private
  def fill_points_and_states(game)
    9.times do |i|
      2.times do |j|
	if game.send("frame0#{i+1}_state#{j+1}") == nil || game.send("frame0#{i+1}_state#{j+1}") == ''
	  eval("game.frame0#{i+1}_state#{j+1} = 'N'")
	end

        if [nil, 0].include? game.send("frame0#{i+1}_result#{j+1}")
          # deduce points from state
	  case game.send("frame0#{i+1}_state#{j+1}")
	  when 'F'
	    eval("game.frame0#{i+1}_result#{j+1} = 0")
	  when '/'
	    eval("game.frame0#{i+1}_result#{j+1} = 10 - game.frame0#{i+1}_result#{j}")
  	  when 'X'
  	    eval("game.frame0#{i+1}_result1 = 10")
	    eval("game.frame0#{i+1}_result2 = nil")
 	  end
        end
      end

      if game.send("frame0#{i+1}_result1") == 10
        eval("game.frame0#{i+1}_state1 = 'X'")
	eval("game.frame0#{i+1}_result2 = nil")
	eval("game.frame0#{i+1}_state2 = nil")
      elsif game.send("frame0#{i+1}_result1") + game.send("frame0#{i+1}_result2") == 10
        eval("game.frame0#{i+1}_state1 = game.frame0#{i+1}_state1 || 'N'")
	eval("game.frame0#{i+1}_state2 = '/'")
      end
    end

    3.times do |j|
      # deduce points from state (frame 10)
      if [nil, 0].include? game.send("frame10_result#{j+1}")
        case game.send("frame10_state#{j+1}")
	when 'F'
	  eval("game.frame10_result#{j+1} = 0")
	when '/'
	  eval("game.frame10_result#{j+1} = 10 - game.frame10_result#{j}")
	when 'X'
	  eval("game.frame10_result#{j+1} = 10")
	end
      end
    end

    if game.frame10_state1 == nil || game.frame10_state1 == ''
      game.frame10_state1 = 'N'
    end
    if game.frame10_state2 == nil || game.frame10_state2 == ''
      game.frame10_state2 = 'N'
    end
    if game.frame10_state3 == nil || game.frame10_state3 == ''
      game.frame10_state3 = 'N'
    end

    if game.frame10_result1 == 10
      game.frame10_state1 = 'X'
    elsif game.frame10_result1 + game.frame10_result2 == 10
      game.frame10_state2 = '/'
    end
    if game.frame10_result2 == 10 and game.frame10_state1 == 'X'
      game.frame10_state2 = 'X'
    elsif game.frame10_state1 == 'X' and game.frame10_result2 + game.frame10_result3 == 10
      game.frame10_state3 = '/'
    end
    if game.frame10_result3 == 10 and %(/ X).include?(game.frame10_state2)
      game.frame10_state3 = 'X'
    elsif %(/ X).include?(game.frame10_state2) and not %(S F / X).include?(game.frame10_state3)
      game.frame10_state3 = 'N'
    end
    if game.frame10_state1 != 'X' and not %(/ X).include?(game.frame10_state2)
      game.frame10_result3 = nil
      game.frame10_state3 = nil
    end
  end

  def fill_aggregations(game)
    game.points = game.points_up_to_frame(10)

    state_methods = game.methods.keep_if { |n| n =~ /state[123]$/ }
    states = []
    state_methods.each { |name| states << game.send(name) }

    game.splits = states.count('S')
    game.strikes = states.count('X')
    game.spares = states.count('/')
    game.fouls = states.count('F')
    game.cleared_frames = states[0...-3].count('/')
    game.cleared_frames += states[0...-3].count('X')
    if states[-3] == 'X' or states[-2] == '/'
      if states[-1] == 'X' or states[-1] == '/'
        game.cleared_frames += 1
      end
    end

    game.cleared_splits = 0
    9.times do |i|
      game.cleared_splits += 1 if game.send("frame0#{i+1}_state1") == 'S' and game.send("frame0#{i+1}_state2") == '/'
    end
    if (states[-3] == 'S' and states[-2] == '/') or (states[-2] == 'S' and states[-1] == '/')
      game.cleared_splits += 1
    end
  end
end
