class CreateCreations < ActiveRecord::Migration
  def change
    create_table :creations do |t|
      t.integer :lm_id
      t.string :imgs
      t.string :categs
      t.string :title
      t.string :subtitle
      t.text :desc
      t.string :tags
      t.string :materials
      t.string :colors
      t.string :styles
      t.string :events
      t.string :dest
      t.string :prices
      t.string :deliveries
      t.string :options

      t.timestamps null: false
    end
  end
end
