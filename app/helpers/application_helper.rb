module ApplicationHelper
  def result_text_field_options
    { :class => "input-mini-mini", :size => 2 }
  end

  def create_dependent_game(number, match)
    game = Game.new
    game.match_day = match
    game.number = number
    return game
  end
end
