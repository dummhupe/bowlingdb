class ReCalculateClearedFrames < ActiveRecord::Migration
  def up
    Game.all.each do |game|
      game.save
    end
  end

  def down
  end
end
