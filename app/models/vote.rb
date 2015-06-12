class Vote < ActiveRecord::Base

  belongs_to :user
  belongs_to :person
  belongs_to :feature
  
  validates_presence_of :user_id, :person_id, :feature_id
  
  scope :include_all, includes(:user, :person, :feature)
  scope :newest, order("created_at DESC").limit(20)

  def self.summary
    group(:feature_id, :person_id).
    order('count_all DESC').
    count
  end

  def self.summary_for_user(user)
    where(user_id: user.id).
    group(:feature_id, :person_id).
    order('count_all DESC').
    count
  end
  
end