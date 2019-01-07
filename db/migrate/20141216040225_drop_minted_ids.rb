class DropMintedIds < ActiveRecord::Migration[4.2]
  def up
    drop_table :minted_ids
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
