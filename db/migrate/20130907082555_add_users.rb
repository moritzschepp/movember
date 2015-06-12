class AddUsers < ActiveRecord::Migration
  def up
    drop_table :users

    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :token

      t.boolean :admin

      t.text :cart
      t.integer :amount_paid
      t.integer :votes_spent

      t.timestamps
    end

    drop_table :configs
  end

  def down
    create_table :configs do |t|
      t.string :name
      t.string :value
      t.timestamps
    end

    drop_table :users

    create_table :users do |t|
      t.string :username
      t.string :password
      t.timestamps
    end
  end
end
