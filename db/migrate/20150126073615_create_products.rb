class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :family_id,           null: false, default: 0
      t.string :number,               null: false, default: ""
      t.string :name,                 null: false, default: ""
      t.integer :status,              null: false, default: 1
      t.datetime :end_support_date

      t.timestamps
    end
    add_index :products, :number
    add_index :products, :family_id
  end
end
