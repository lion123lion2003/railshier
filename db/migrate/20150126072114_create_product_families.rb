class CreateProductFamilies < ActiveRecord::Migration
  def change
    create_table :product_families do |t|
      t.string        :name,     null: false, default: ""
      t.string :description,     null: false, default: ""

      t.timestamps
    end
    add_index :product_families, :name
  end
end
