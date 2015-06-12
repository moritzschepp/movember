class User < ActiveRecord::Base
  
  serialize :cart

  has_many :votes

  after_validation :ensure_token, :random_casting

  validates_uniqueness_of :email

  attr_accessor :cast_randomly

  def ensure_token
    self.token ||= generate_token
    self.password ||= self.token.first(6)
  end

  def generate_token
    Digest::SHA1.hexdigest "#{Time.now} #{rand} - MOVEMBER KEY - #{AppConfig.get 'token_secret'}"
  end

  def random_casting
    if self.cast_randomly && self.cast_randomly != "0"
      feature_ids = Feature.all.map{|f| f.id}
      person_ids = Person.all.map{|p| p.id}

      while votes_left?
        self.votes.create(
          :feature_id => feature_ids.shuffle.first,
          :person_id => person_ids.shuffle.first
        )
      end
    end
  end

  def self.login(credentials = {})
    if credentials[:email].present? && credentials[:password].present?
      where(email: credentials[:email], password: credentials[:password]).first
    else
      if credentials[:token].present?
        where(token: credentials[:token]).first
      end
    end
  end

  def self.total_income
    tshirt_cash = 0

    User.all.each do |u|
      if u.cart["t_shirt"] && u.cart["t_shirt"]["amount"].present?
        tshirt_cash += u.cart["t_shirt"]["amount"].to_i * 20
      end
      
      if u.cart["mug"] && u.cart["mug"]["amount"].present?
        tshirt_cash += u.cart["mug"]["amount"].to_i * 10
      end
    end

    User.sum(:amount_paid) - tshirt_cash
  end

  scope :search, lambda{|terms|
    result = order("amount_paid DESC").limit(20)
    if terms.present?
      result = result.where("email LIKE ?", "%#{terms}%")
    end
    result
  }

  def votes_left?
    votes_left > 0
  end

  def cart
    self[:cart] ||= {}
  end

  def votes_spent
    votes.count
  end

  def votes_left
    votes_bought = (cart['vote'] || {})['amount'] || 0
    votes_bought.to_i - votes_spent
  end

end