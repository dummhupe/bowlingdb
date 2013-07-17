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
  end
end
