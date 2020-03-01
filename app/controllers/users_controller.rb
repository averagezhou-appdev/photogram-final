class UsersController < ApplicationController
  skip_before_action(:force_user_sign_in, { :only => [:new_registration_form, :create, :index, :show] })
  def new_registration_form
    render({ :template => "user_sessions/sign_up.html.erb" })
  end

  def create
    @user = User.new
    @user.email = params.fetch("query_email")
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    @user.is_private = params.fetch("query_is_private", false)
    @user.username = params.fetch("query_username")
    @user.comments_count = params.fetch("query_comments_count")
    @user.likes_count = params.fetch("query_likes_count")

    save_status = @user.save

    if save_status == true
      session.store(:user_id,  @user.id)
   
      redirect_to("/", { :notice => "User account created successfully."})
    else
      redirect_to("/user_sign_up", { :alert => "User account failed to create successfully."})
    end
  end
    
  def edit_registration_form
    render({ :template => "users/edit_profile.html.erb" })
  end

  def update
    @user = @current_user
    @user.email = params.fetch("query_email")
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    @user.is_private = params.fetch("query_is_private", false)
    @user.username = params.fetch("query_username")
    @user.comments_count = params.fetch("query_comments_count")
    @user.likes_count = params.fetch("query_likes_count")
    
    if @user.valid?
      @user.save

      redirect_to("/", { :notice => "User account updated successfully."})
    else
      render({ :template => "users/edit_profile_with_errors.html.erb" })
    end
  end

  def destroy
    @current_user.destroy
    reset_session
    
    redirect_to("/", { :notice => "User account cancelled" })
  end


  def index
    @users = User.all.order({ :username => :asc })
    render({ :template => "users/index.html.erb" })
  end


  def show
    the_username = params.fetch("path_id")
    @user = User.where({ :username => the_username }).at(0)
    if session.fetch(:user_id) == @user.id
      render({ :template => "users/show.html.erb"})
    else
    redirect_to("/", { :notice => "Not your account, b*tch >:(" })
    end
  end

  def feed
    the_username = params.fetch("path_id")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/feed.html.erb"})
  end

  def likes
    the_username = params.fetch("path_id")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/likes.html.erb"})
  end

  def discover
    the_username = params.fetch("path_id")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/discover.html.erb"})
  end

  
end
