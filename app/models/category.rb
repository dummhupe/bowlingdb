class Category < ActiveRecord::Base
  attr_accessible :name
  validates :name, :presence => true

  has_many :match_day, :inverse_of => :category, :dependent => :destroy
  
  def self.categories_for_selection
    Category.all(:order => 'name').collect { |c|
      [c.name, c.id]
    }
  end
end
