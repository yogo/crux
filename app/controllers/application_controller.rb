# This actually can cause issues:(
# require 'dm-rails/middleware/identity_map'

class ApplicationController < ActionController::Base
  # use Rails::DataMapper::Middleware::IdentityMap
  protect_from_forgery
  
  before_filter :basic_auth
  
  def basic_auth
    # If it's local, let it go. For development
    return true if ["127.0.0.1", "0:0:0:0:0:0:0:1%0"].include?(request.env["REMOTE_ADDR"])
    authenticate_or_request_with_http_basic do |id, password|
      id == 'crux' && password == 'preston'
    end
  end
  
end
