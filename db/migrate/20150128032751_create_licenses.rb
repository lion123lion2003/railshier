class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.string :name,              null: false, default: ""
      t.string :keyword,           null: false, default: ""
      t.integer :author_id,       null: false, default: 0
      t.integer :requestor_id,    null: false, default: 0
      t.string :hostid,            null: false, default: ""
      #t.datetime :effective_date,  null: false, default: ""
      #t.datetime :request_date,    null: false, default: ""
      t.datetime :effective_date
      t.datetime :request_date
      t.string :customer_organization, null: false, default: ""
      t.string :customer_manager,      null: false, default: ""
      t.string :project_name,          null: false, default: ""
      t.string :usage,                 null: false, default: ""

      t.timestamps
    end
    add_index :licenses, :author_id,     unique: false

    create_table :product_licenses do |t|
      t.integer :license_id,     null: false, default: ""
      t.integer :product_id,     null: false, default: ""
      t.integer :quantity,       null: false, default: ""
      t.datetime :expire_date

      t.timestamps
    end
    add_index :product_licenses, [:license_id, :product_id], unique: true

  end
end
