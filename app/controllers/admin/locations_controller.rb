class Admin::LocationsController < Admin::BaseController
  def index
    @locations = Location.order("name")
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(params[:location])
    if @location.save
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(params[:location])
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    redirect_to :action => :index
  end
end
