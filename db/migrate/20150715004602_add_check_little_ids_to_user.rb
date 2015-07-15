class AddCheckLittleIdsToUser < ActiveRecord::Migration
  def change
    add_column :users, :check_little_ids, :boolean, default: false
  end
end
