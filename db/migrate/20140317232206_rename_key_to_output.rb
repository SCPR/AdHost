class RenameKeyToOutput < ActiveRecord::Migration
  def change
    rename_column :preroller_campaigns, :key, :output_key
    rename_column :visual_campaigns, :key, :output_key
  end
end
