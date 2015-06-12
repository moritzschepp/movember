class Feature < ActiveRecord::Base
  # attr_accessible :name, :description, :picture
  
  has_attached_file(:picture,
    :url => "/system/:class/:id/:style/:filename",
    :default_url => 'mustache.jpg',
    :styles => {
      :icon => "80x80#",
      :preview => "320x320#",
      :showcase => "640x640#"
    }
  )
end
