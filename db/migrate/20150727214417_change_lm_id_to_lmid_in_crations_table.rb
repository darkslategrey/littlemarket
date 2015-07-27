class ChangeLmIdToLmidInCrationsTable < ActiveRecord::Migration
  def change
    rename_column :creations, :lm_id, :lmid    
  end
end
