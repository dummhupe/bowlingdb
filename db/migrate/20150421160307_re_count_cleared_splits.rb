class ReCountClearedSplits < ActiveRecord::Migration
  def up
    Game.all.each do |g|
      g.save
    end
  end

  def down
  end
end
