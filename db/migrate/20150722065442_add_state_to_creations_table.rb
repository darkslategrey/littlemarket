class AddStateToCreationsTable < ActiveRecord::Migration
  def change
    add_column :creations, :state, :string, default: 'published'
  end
end
