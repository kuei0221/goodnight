class AddDurationToSleeps < ActiveRecord::Migration[6.1]
  def up
    add_column :sleeps, :duration, :integer

    Sleep.update_all("duration = strftime('%s', end_at) - strftime('%s', start_at)")
  end

  def down
    remove_column :sleeps, :duration
  end
end
