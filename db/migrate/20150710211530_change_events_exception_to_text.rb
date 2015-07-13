class ChangeEventsExceptionToText < ActiveRecord::Migration
  def up
    change_column :events, :exception, :text
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
