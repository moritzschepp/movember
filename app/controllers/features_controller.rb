class FeaturesController < ApplicationController

  def index
    @features = Feature.all

    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    @feature = Feature.new
  end

  def edit
    @feature = Feature.find(params[:id])
  end

  def create
    @feature = Feature.new(params[:feature].permit(:name, :description, :picture))

    if @feature.save
      redirect_to features_path, :notice => 'Feature was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    @feature = Feature.find(params[:id])

    if @feature.update_attributes(params[:feature].permit(:name, :description, :picture))
      redirect_to features_path, :notice => 'Feature was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @feature = Feature.find(params[:id])
    @feature.destroy
    
    redirect_to features_url
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
