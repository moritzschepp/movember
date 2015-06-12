class PeopleController < ApplicationController

  def index
    @people = Person.order("first_name ASC, last_name ASC")

    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    @person = Person.new
  end

  def edit
    @person = Person.find(params[:id])
  end

  def create
    @person = Person.new(params[:person].permit(:first_name, :last_name, :picture, :description))

    if @person.save
      redirect_to people_path, :notice => 'Person was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    @person = Person.find(params[:id])

    if @person.update_attributes(params[:person].permit(:first_name, :last_name, :picture, :description))
      redirect_to people_path, :notice => 'Person was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    redirect_to people_url
  end


  protected

    def authorized?
      if action_name == "index"
        true
      else
        super
      end
    end
end
