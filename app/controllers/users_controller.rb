class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
   # 
   # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])

    @user.save!
    self.current_user = @user
    redirect_back_or_default('/')
    session[:user_id] = @user.id
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

end
