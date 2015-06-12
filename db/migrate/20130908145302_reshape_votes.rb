class ReshapeVotes < ActiveRecord::Migration
  def up
    change_table :votes do |t|
      t.integer :user_id

      t.remove :key
      t.remove :qr_code_updated_at
      t.remove :qr_code_file_size
      t.remove :qr_code_content_type
      t.remove :qr_code_file_name
      t.remove :state
    end

    change_table :users do |t|
      t.remove :votes_spent
    end
  end

  def down
    change_table :users do |t|
      t.integer :votes_spent
    end

    change_table :votes do |t|
      t.remove :user_id

      t.string   :key
      t.datetime :qr_code_updated_at
      t.integer  :qr_code_file_size
      t.string   :qr_code_content_type
      t.string   :qr_code_file_name
      t.string   :state
    end
  end
end
