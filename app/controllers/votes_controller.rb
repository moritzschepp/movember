class VotesController < ApplicationController

  skip_before_filter :auth, :only => [:index]
  protect_from_forgery :except => :create

  def index
    respond_to do |format|
      format.html do
        @votes = Vote.summary
        @features = {}
        @people = {}

        Feature.where(:id => @votes.keys.map{|k| k.first}).each do |feature|
          @features[feature.id] = feature
        end
        Person.where(:id => @votes.keys.map{|k| k.last}).each do |person|
          @people[person.id] = person
        end
      end
      format.json do
        @votes = Vote.group(:feature_id, :person_id).count
        @ordered_votes = @votes.to_a.sort do |x, y|
          y[1] <=> x[1]
        end
      end
    end
  end

  def personal
    respond_to do |format|
      format.html do
        @votes = Vote.summary_for_user(current_user)
        @features = {}
        @people = {}

        Feature.find(@votes.keys.map{|k| k.first}).each do |feature|
          @features[feature.id] = feature
        end
        Person.find(@votes.keys.map{|k| k.last}).each do |person|
          @people[person.id] = person
        end
      end
      format.json do
        @votes = Vote.where(:user => current_user).group(:feature_id, :person_id).count
        render :json => @votes
      end
    end
  end

  def new
    @votes = Vote.summary_for_user(current_user)
    @people = Person.all
    @features = Feature.all
    @vote = current_user.votes.build(params.permit(vote: [:feature_id, :person_id]))
  end

  def create
    respond_to do |format|
      format.html do
        if current_user.votes_left > 0
          if Time.parse(MoVember.config["ends_at"]) > Time.now
            @vote = current_user.votes.build(params[:vote].permit(:feature_id, :person_id))

            if @vote.save
              flash[:notice] = "Vote cast successfully"
              redirect_to :action => "new"
            else
              render :action => "new"
            end
          else
            flash[:error] = "Sorry, you can't vote anymore!"
            redirect_to :action => "new"
          end
        else
          flash[:error] = "You don't have any votes left"
          redirect_to :action => "new"
        end
      end
      format.json do
        if current_user.votes_left > 0
          if Time.parse(MoVember.config["ends_at"]) > Time.now
            @vote = current_user.votes.build(params[:vote].permit(:feature_id, :person_id))

            if @vote.save
              render :json => {"message" => "Vote cast successfully"}
            else
              render :json => @vote.errors, :status => 406
            end
          else
            render :json => {"message" => "Sorry, you can't vote anymore!"}, :status => 406
          end
        else
          render :json => {"message" => "You don't have any votes left"}, :status => 406
        end
      end
    end
  end
  
  def destroy
    @votes = current_user.votes.where(:person_id => params[:person_id], :feature_id => params[:feature_id])
    @votes.first.destroy

    flash[:notice] = "Vote drawn back"
    redirect_to :action => "new"
  end
  

  protected

    def authorized?
      true
    end
end


# @order = Vote.
#         select('feature_id, person_id, count(*) as co').
#         group(:feature_id, :person_id).
#         order('co DESC')
      
#       @by_combination = @order.select{|o| o.feature_id && o.person_id}.map do |o|
#         result = {
#           :person => Person.find(o.person_id),
#           :feature => Feature.find(o.feature_id),
#           :count => o.co
#         }
#       end
        
#       @by_person = @by_combination.group_by do |c|
#         c[:person]
#       end