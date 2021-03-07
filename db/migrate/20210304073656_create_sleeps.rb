class CreateSleeps < ActiveRecord::Migration[6.1]
  def change
    create_table :sleeps do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
