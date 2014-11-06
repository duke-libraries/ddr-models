class CreateMintedIds < ActiveRecord::Migration
  def up
    unless table_exists?("minted_ids")
      create_table "minted_ids" do |t|
        t.string   "minted_id"
        t.string   "referent"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      add_index "minted_ids", ["minted_id"], name: "index_minted_ids_on_minted_id", unique: true
      add_index "minted_ids", ["referent"], name: "index_minted_ids_on_referent"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
