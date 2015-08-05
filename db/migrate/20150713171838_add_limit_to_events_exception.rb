class AddLimitToEventsException < ActiveRecord::Migration
  def up
    change_column :events, :exception, :text, limit: 65535
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
