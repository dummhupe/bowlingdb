class Admin::CategoriesController < Admin::BaseController
  def index
    @categories = Category.order("name")
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end

  def destroy 
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to :action => :index
   end
end
