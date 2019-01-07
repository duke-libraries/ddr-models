class DropWorkflowStates < ActiveRecord::Migration[4.2]
  def up
    if table_exists?("workflow_states")
      drop_table "workflow_states"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
