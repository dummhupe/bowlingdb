class Admin::PlayersController < Admin::BaseController
  def index
    @players = Player.order("lastname", "firstname")
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(params[:player])
    if @player.save
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  def edit
    @player = Player.find(params[:id])
  end

  def update
    @player = Player.find(params[:id])
    if @player.update_attributes(params[:player])
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end

  def destroy
    @player = Player.find(params[:id])
    @player.destroy
    redirect_to :action => :index
  end
end
