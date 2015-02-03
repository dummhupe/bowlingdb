class CreditsController < ApplicationController
  def index
    @stats = {}
    @stats[:player_count] = Player.count
    @stats[:location_count] = Location.count
    @stats[:match_day_count] = []
    
    Category.order(:name).each do |c|
      item = {}
      item[:category] = c.name
      item[:count] = MatchDay.where(:category_id => c).count
      @stats[:match_day_count] << item
    end
    item = {}
    item[:category] = "Summe"
    item[:count] = MatchDay.count
    @stats[:match_day_count] << item

    @stats[:first_match_day] = MatchDay.where(:match_day => MatchDay.minimum(:match_day)).order(:id).first
    @stats[:last_match_day] = MatchDay.where(:match_day => MatchDay.maximum(:match_day)).order(:id).last

    @stats[:best_game] = Game.where(:points => Game.maximum(:points)).order(:id).last
    @stats[:worst_game] = Game.where(:points => Game.minimum(:points)).order(:id).last
  end
end
