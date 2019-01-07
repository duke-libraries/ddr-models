class AddLimitToEventsException < ActiveRecord::Migration[4.2]
  def up
    change_column :events, :exception, :text, limit: 65535
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
