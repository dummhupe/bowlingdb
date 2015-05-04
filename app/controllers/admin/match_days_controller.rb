class Admin::MatchDaysController < Admin::BaseController
  WillPaginate.per_page = 5

  def index
    @match_days = MatchDay.order('match_day DESC, id DESC').paginate(:page => params[:page])
  end

  def new
    @match_day = MatchDay.new
  end

  def create
    @match_day = MatchDay.new(params[:match_day])
    @match_day.category = Category.find(params[:match_objects][:category])
    @match_day.location = Location.find(params[:match_objects][:location])
    if @match_day.save
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  def edit
    @match_day = MatchDay.find(params[:id])
  end

  def update
    @match_day = MatchDay.find(params[:id])
    @match_day.category = Category.find(params[:match_objects][:category])
    @match_day.location = Location.find(params[:match_objects][:location])
    if @match_day.update_attributes(params[:match_day])
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end

  def destroy
    @match_day = MatchDay.find(params[:id])
    @match_day.destroy
    redirect_to :action => :index
  end
end
