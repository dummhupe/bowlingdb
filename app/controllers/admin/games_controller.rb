class Admin::GamesController < Admin::BaseController
  def index
    @games = Game.all
  end

  def new
    match = MatchDay.find(params[:match_day_id])
    @game = Game.new
    @game.match_day = match
    @game.player = Player.find(Player.players_for_selection.first[1])
    @game.number = Game.where('match_day_id = ?', params[:match_day_id]).maximum('number')
  end

  def create
    @game = Game.new(params[:game])
    @game.match_day = MatchDay.find(params[:game_objects][:match_day])
    @game.player = Player.find(params[:game_objects][:player])
    if @game.save
      redirect_to admin_match_days_path
    else
      render :action => :new
    end
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    @game.player = Player.find(params[:game_objects][:player])
    if @game.update_attributes(params[:game])
      redirect_to admin_match_days_path
    else
      render :action => :edit
    end
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    redirect_to :controller => :match_days
  end
end
