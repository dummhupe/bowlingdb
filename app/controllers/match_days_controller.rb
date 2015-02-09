class MatchDaysController < ApplicationController
  WillPaginate.per_page = 20

  def index
    @match_days = MatchDay.order('match_day DESC').paginate(:page => params[:page])
  end

  def latest
    redirect_to match_day_path(MatchDay.order('match_day DESC').first)
  end

  def show
    @match_day = MatchDay.find(params[:id])
    @state_mapping = {
      'N' => 'normal',
      'S' => 'split',
      'F' => 'foul',
      '/' => 'spare',
      'X' => 'strike'
    }

    @extrema = {}
    # maxima
    [:strikes, :spares, :average, :cleared_splits, :points, :high_game, :low_game].each do |cstic|
      @extrema[cstic] = 0
      @match_day.players.each do |p|
        value = p.send(cstic, @match_day) 
	if @extrema[cstic] < value
	  @extrema[cstic] = value
	end
      end
    end
    # minima
    [:splits, :gutter, :fouls, :open].each do |cstic|
      @extrema[cstic] = 999999
      @match_day.players.each do |p|
        value = p.send(cstic, @match_day)
	if @extrema[cstic] > value
	  @extrema[cstic] = value
	end
      end
    end
    @extrema[:diff] = 999999
    @match_day.players.each do |p|
      value = p.high_game(@match_day) - p.low_game(@match_day)
      if @extrema[:diff] > value
        @extrema[:diff] = value
      end
    end
  end

  def show_charts
  end
end
