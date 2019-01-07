class AddUserKeyToEvents < ActiveRecord::Migration[4.2]
  def change
    change_table :events do |t|
      t.string :user_key
    end
  end
end
