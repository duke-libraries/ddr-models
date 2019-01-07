class AddExceptionToEvents < ActiveRecord::Migration[4.2]
  def change
    change_table :events do |t|
      t.string :exception
    end
  end
end
