class Visit < ActiveRecord::Base
  has_many :ahoy_events, class_name: "Ahoy::Event"
  has_many :user_events, class_name: "Ahoy::Event", conditions: {:group => 'user'}
  has_many :admin_events, class_name: "Ahoy::Event", conditions: {:group => 'admin'}
  belongs_to :user
end
