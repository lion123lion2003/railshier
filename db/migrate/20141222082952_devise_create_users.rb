class DeviseCreateUsers < ActiveRecord::Migration
  def up
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :login,               null: false, default: ""
      t.string :email,               null: false, default: ""
      t.integer :status,             null: false, default: 1
      t.boolean :admin,              null: false, default: false
      t.string :firstname,           null: false, default: "", limit: 30
      t.string :lastname,            null: false, default: "", limit: 30
      t.boolean :email_notification, null: false, default: true
      t.string :type,                null: false, default: ""
      t.string :encrypted_password,  null: false, default: ""
      t.integer :source,             null: false, default: 0
      t.integer :primary_id,         null: false, default: 0

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps
    end

    #add_index :users, :email,                 unique: true
    add_index :users, :login,                unique: false
    #add_index :users, :login
    #add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true

    create_table :groups_users, :id => false do |t|
        t.column :group_id, :integer, :null => false
        t.column :user_id,  :integer, :null => false
    end
    add_index :groups_users, [:group_id, :user_id], :unique => true, :name => :groups_users_ids


    # create default administrator account
    User.create :login => "admin",
    #            :encrypted_password => "$2a$10$OZvuwO56/e1uMUbOusJAzuzEgFOVgwWBi8ZmK//FVGqdtpyPJ.qdi",
                :password => "admin",
                :admin => true,
                :firstname => "admin",
                :lastname => "admin",
                :email => "admin@example.com"
  end


  def down
      drop_table(:groups_users)
      drop_table(:users)
  end

end
