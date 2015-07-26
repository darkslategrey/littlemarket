class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|
      t.string :hex
      t.string :name

      t.timestamps null: false
    end
  end
end
