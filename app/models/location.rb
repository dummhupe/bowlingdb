class Location < ActiveRecord::Base
   attr_accessible :name
   validates :name, :presence => true

   has_many :match_day, :inverse_of => :location, :dependent => :destroy

   def self.locations_for_selection
     Location.all(:order => 'name').map { |l|
       [l.name, l.id]
     }
   end
end
