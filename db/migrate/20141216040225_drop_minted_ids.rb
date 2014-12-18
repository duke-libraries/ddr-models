class DropMintedIds < ActiveRecord::Migration
  def up
    drop_table :minted_ids
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
