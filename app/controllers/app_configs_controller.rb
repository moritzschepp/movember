class AppConfigsController < ApplicationController

  def index
    @app_configs = AppConfig.all
  end

  def update_all
    params[:app_configs].each do |a|
      AppConfig.set a[:name], a[:value], a[:kind]
    end

    redirect_to action: :index
  end

end