class ChangeEventsExceptionToText < ActiveRecord::Migration[4.2]
  def up
    change_column :events, :exception, :text
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
