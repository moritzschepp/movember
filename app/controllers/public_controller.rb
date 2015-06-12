class PublicController < ApplicationController
  
  skip_before_filter :auth

  def info
    respond_to do |format|
      format.json do
        render :json => app_config
      end
    end
  end
  
  def index
    # get_results if App.over?
  end
  
  def thanks
    
  end
  
  def over
    
  end
  
  # def results
  #   get_results
  # end
  
  def data
    response = {
      :people => Person.all.map{|p| {:name => p.display_name, :url => p.picture.url(:showcase)}},
      :features => Feature.all.map{|p| {:name => p.name, :url => p.picture.url(:showcase)}}
    }
    
    render :json => response
  end
  
  
  protected
  
    def get_results
      @order = Vote.
        where(:state => 'voted').
        select('feature_id, person_id, count(*) as co').
        group(:feature_id, :person_id).
        order('co DESC')
      
      @by_combination = @order.select{|o| o.feature_id && o.person_id}.map do |o|
        result = {
          :person => Person.find(o.person_id),
          :feature => Feature.find(o.feature_id),
          :count => o.co
        }
      end
        
      @by_person = @by_combination.group_by do |c|
        c[:person]
      end
    end
  
end
