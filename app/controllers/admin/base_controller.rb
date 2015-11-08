class Admin::BaseController < ApplicationController
  layout 'admin'

  before_filter :track_event

  http_basic_authenticate_with :name => 'test', :password => 'test'

  def track_event
    ahoy.track "#{controller_name}##{action_name}", :group => :admin, :params => params
  end
end
