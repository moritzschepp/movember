class Person < ActiveRecord::Base
  # attr_accessible :first_name, :last_name, :description, :picture

  has_many :votes
  
  validates_presence_of :first_name, :last_name, :picture
  
  has_attached_file(:picture,
    :url => "/system/:class/:id/:style/:filename",
    :path => "#{Rails.root}/public/system/:class/:id/:style/:filename",
    :default_url => 'male.jpg',
    :styles => {
      :icon => "80x80#",
      :preview => "320x320#",
      :showcase => "640x640#"
    }
  )
  
  def display_name
    "#{first_name} #{last_name}"
  end
end
