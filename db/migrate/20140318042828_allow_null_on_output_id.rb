class AllowNullOnOutputId < ActiveRecord::Migration
  def up
    change_column :preroller_campaigns, :output_id, :integer, :null => true
    change_column :preroller_campaigns, :starts_at, :datetime, :null => true
    change_column :preroller_campaigns, :ends_at, :datetime, :null => true
  end

  def down
    change_column :preroller_campaigns, :output_id, :integer, :null => false
    change_column :preroller_campaigns, :starts_at, :datetime, :null => false
    change_column :preroller_campaigns, :ends_at, :datetime, :null => false
  end
end
