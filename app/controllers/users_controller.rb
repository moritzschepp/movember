class UsersController < ApplicationController

  def me
    @user = current_user

    respond_to do |format|
      format.json
    end
  end

  def index
    respond_to do |format|
      format.html
      format.json do
        @users = User.search(params[:terms])
      end
    end
  end

  def new
    @user = User.new(params[:user].permit(:email, :amount_paid, :cart))

    respond_to do |format|
      format.html
      format.json
    end
  end

  def edit
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
      format.json do
        render :action => "new"
      end
    end
  end

  def create
    @user = User.new(params[:user].to_options)
    if @user.save
      flash[:notice] = "User created"
      if @user.email != "admin@example.com" && params[:commit] == "Save"
        UserMailer.notify_payment(@user, authenticate_url(:credentials => {:token => @user.token})).deliver
      end
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes params[:user].to_options
      flash[:notice] = "User saved"
      if @user.email != "admin@example.com" && params[:commit] == "Save"
        UserMailer.notify_payment(@user, authenticate_url(:credentials => {:token => @user.token})).deliver
      end
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user
      flash[:notice] = "User has been deleted"
      @user.destroy
      redirect_to :action => "index"
    else
      flash[:error] = "User doesn't exist"
      redirect_to root_url
    end
  end


  protected

    def authorized?
      if action_name == "me"
        true
      else
        super
      end
    end

end