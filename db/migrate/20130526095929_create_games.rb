class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :number, :null => false
      t.references :match_day, :null => false
      t.references :player, :null => false

      t.integer :frame01_result1, :null => false, :default => 0
      t.column  :frame01_state1, 'CHAR(1)', :null => false 
      t.integer :frame01_result2, :null => true, :default => 0
      t.column  :frame01_state2,  'CHAR(1)', :null => true
      t.integer :frame02_result1, :null => false, :default => 0
      t.column  :frame02_state1,  'CHAR(1)', :null => false
      t.integer :frame02_result2, :null => true, :default => 0
      t.column  :frame02_state2,  'CHAR(1)', :null => true
      t.integer :frame03_result1, :null => false, :default => 0
      t.column  :frame03_state1,  'CHAR(1)', :null => false
      t.integer :frame03_result2, :null => true, :default => 0
      t.column  :frame03_state2,  'CHAR(1)', :null => true
      t.integer :frame04_result1, :null => false, :default => 0
      t.column  :frame04_state1,  'CHAR(1)', :null => false
      t.integer :frame04_result2, :null => true, :default => 0
      t.column  :frame04_state2,  'CHAR(1)', :null => true
      t.integer :frame05_result1, :null => false, :default => 0
      t.column  :frame05_state1,  'CHAR(1)', :null => false
      t.integer :frame05_result2, :null => true, :default => 0
      t.column  :frame05_state2,  'CHAR(1)', :null => true
      t.integer :frame06_result1, :null => false, :default => 0
      t.column  :frame06_state1,  'CHAR(1)', :null => false
      t.integer :frame06_result2, :null => true, :default => 0
      t.column  :frame06_state2,  'CHAR(1)', :null => true
      t.integer :frame07_result1, :null => false, :default => 0
      t.column  :frame07_state1,  'CHAR(1)', :null => false
      t.integer :frame07_result2, :null => true, :default => 0
      t.column  :frame07_state2,  'CHAR(1)', :null => true
      t.integer :frame08_result1, :null => false, :default => 0
      t.column  :frame08_state1,  'CHAR(1)', :null => false
      t.integer :frame08_result2, :null => true, :default => 0
      t.column  :frame08_state2,  'CHAR(1)', :null => true
      t.integer :frame09_result1, :null => false, :default => 0
      t.column  :frame09_state1,  'CHAR(1)', :null => false
      t.integer :frame09_result2, :null => true, :default => 0
      t.column  :frame09_state2,  'CHAR(1)', :null => true
      t.integer :frame10_result1, :null => false, :default => 0
      t.column  :frame10_state1,  'CHAR(1)', :null => false
      t.integer :frame10_result2, :null => false, :default => 0
      t.column  :frame10_state2,  'CHAR(1)', :null => false
      t.integer :frame10_result3, :null => true, :default => 0
      t.column  :frame10_state3,  'CHAR(1)', :null => true

      t.integer :points, :null => false, :default => 0
      t.integer :cleared_frames, :null => false, :default => 0
      t.integer :strikes, :null => false, :default => 0
      t.integer :spares, :null => false, :default => 0
      t.integer :fouls, :null => false, :default => 0
      t.integer :splits, :null => false, :default => 0
      t.integer :cleared_splits, :null => false, :default => 0

      t.timestamps
    end
  end
end
