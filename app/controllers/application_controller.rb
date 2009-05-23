class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password

  def index
    render "/index", :layout => true
  end

  def complete_city
    @phrase = params[:city]
    @cities = City.all(:select => "cities.name, co.name AS country_name", :joins => "LEFT JOIN countries co ON cities.country_code = co.country_code", :conditions => ["cities.name LIKE ?", "%#{@phrase}%"], :limit => 10)
    render :inline => <<-INLINE
      <ul>
      <% @cities.each do |city| %>
        <li><%= highlight(city.name, @phrase) %>, <%= city.country_name %></li>
      <% end %>
      </ul>
    INLINE
  end
end
