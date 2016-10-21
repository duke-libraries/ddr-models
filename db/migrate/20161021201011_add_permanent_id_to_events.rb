class AddPermanentIdToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.string :permanent_id
      t.index :permanent_id
    end
  end
end
