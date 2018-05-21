class RemoveAhoy < ActiveRecord::Migration
  def up
    drop_table :ahoy_events
    drop_table :visits
  end

  def down
  end
end
