class Init < ActiveRecord::Migration
  def up
    create_table :configs do |t|
      t.string :name
      t.string :value
      
      t.timestamps
    end
  
    create_table :users do |t|
      t.string :username
      t.string :password
      
      t.timestamps
    end
  
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.text :description
      
      t.has_attached_file :picture
      
      t.timestamps
    end
    
    create_table :features do |t|
      t.string :name
      t.text :description
      
      t.has_attached_file :picture
      
      t.timestamps
    end
    
    create_table :votes do |t|
      t.string :key
      t.has_attached_file :qr_code
      
      t.string :state
      
      t.integer :person_id
      t.integer :feature_id
      
      t.timestamps
    end
  end

  def down
    drop_table :votes
    drop_table :features
    drop_table :people
    drop_table :users
    drop_table :configs
  end
end
