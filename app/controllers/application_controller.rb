# This actually can cause issues:(
# require 'dm-rails/middleware/identity_map'

class ApplicationController < ActionController::Base
  # use Rails::DataMapper::Middleware::IdentityMap
  extend Yogo::Chainable
  protect_from_forgery
  
  # before_filter :basic_auth
  
  def no_blueprint
    @no_blueprint = true
  end
  
  def basic_auth
    # If it's local, let it go. For development
    return true if ["127.0.0.1", "0:0:0:0:0:0:0:1%0"].include?(request.env["REMOTE_ADDR"])
    authenticate_or_request_with_http_basic do |id, password|
      id == 'crux' && password == 'preston'
    end
  end
  
  # Adds in the awesome with_responder block
  # Allows modification of the current controllers responder object through blocks
  extendable do
    def with_responder(&block)
      self.responder = Class.new(self.responder || ::ActionController::Responder)
      self.responder.extend(Yogo::Chainable)
      self.responder.chainable(&block)
      self.responder
    end
  end
end
