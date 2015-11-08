class AddGroupToAhoyEvents < ActiveRecord::Migration
  def change
    add_column :ahoy_events, :group, :string
  end
end
