class AddPermanentIdToEvents < ActiveRecord::Migration[4.2]
  def change
    change_table :events do |t|
      t.string :permanent_id
      t.index :permanent_id
    end
  end
end
