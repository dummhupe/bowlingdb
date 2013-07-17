class Player < ActiveRecord::Base
  attr_accessible :firstname, :lastname
  validates :firstname, :presence => true

  has_many :game, :inverse_of => :player, :dependent => :destroy
  
  def self.players_for_selection
    Player.all(:order => ['lastname', 'firstname']).map { |p|
      [p.full_name, p.id]
    }
  end

  def full_name
    firstname + " " + lastname
  end
end
