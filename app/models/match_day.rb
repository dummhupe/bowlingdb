class MatchDay < ActiveRecord::Base
  attr_accessible :match_day, :location, :category

  validates :match_day, :presence => true, :format => { :with => /\d{4}-\d{2}-\d{2}/ }
  validates :category, :presence => true
  validates :location, :presence => true

  belongs_to :category, :inverse_of => :match_day
  belongs_to :location, :inverse_of => :match_day
  has_many :game, :inverse_of => :match_day, :order => [:number, :id], :dependent => :destroy

  def formatted_match_day
    match_day.strftime("%d.%m.%Y")
  end
end
