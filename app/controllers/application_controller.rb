class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password

  def index
    render "/index", :layout => true
  end

  def complete_city
    # @items = [{:name => "Tokyo"},{:name => "Osaka"}]
    @phrase = params[:city]
    @items = City.all(:conditions => ["name LIKE ?", "%#{@phrase}%"], :limit => 10)
    render :inline => "<%= auto_complete_result @items, :name, @phrase %>"
  end
end
