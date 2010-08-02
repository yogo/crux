class UsersController < InheritedResources::Base
  respond_to :html, :json

  protected

  def resource
    @user ||= collection.get(params[:id])
  end
  
  def collection
    @users ||= User.all
  end
  
end
