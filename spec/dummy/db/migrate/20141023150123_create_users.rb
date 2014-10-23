class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string "username", default: "", null: false
    end
  end
end
