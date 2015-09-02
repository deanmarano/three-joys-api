class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.uuid :user_id
      t.string :token

      t.timestamps null: false
    end
  end
end
