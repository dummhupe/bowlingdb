class CreateMatchDays < ActiveRecord::Migration
  def change
    create_table :match_days do |t|
      t.date :match_day, :null => false
      t.references :location, :null => false
      t.references :category, :null => false

      t.timestamps
    end
  end
end
