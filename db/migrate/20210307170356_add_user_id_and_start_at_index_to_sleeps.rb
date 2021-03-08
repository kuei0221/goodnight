class AddUserIdAndStartAtIndexToSleeps < ActiveRecord::Migration[6.1]
  def change
    add_index :sleeps, [:user_id, :start_at]
  end
end
