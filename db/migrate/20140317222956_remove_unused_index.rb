class RemoveUnusedIndex < ActiveRecord::Migration
  def up
    remove_index :preroller_campaigns, :name => "active_status"
    add_index :preroller_campaigns, [:starts_at, :ends_at]

    remove_index :preroller_campaigns, :output_id
  end

  def down
    add_index :preroller_campaigns, [:active, :starts_at, :ends_at], :name => "active_status"
    remove_index :preroller_campaigns, [:starts_at, :ends_at]

    add_index :preroller_campaigns, :output_id
  end
end
