class Admin::StatsController < Admin::BaseController
  def index
    @visits = Visit.order('started_at DESC').paginate(:page => params[:page])
  end

  def show
    @visit = Visit.find(params[:id])
  end
end
