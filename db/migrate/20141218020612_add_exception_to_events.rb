class AddExceptionToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.string :exception
    end
  end
end
