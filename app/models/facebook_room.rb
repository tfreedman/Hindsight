class FacebookRoom < ActiveRecord::Base
  serialize :participants
  establish_connection :hindsight
  has_many :messages, :foreign_key => 'room_id', :class_name => "FacebookMessage", :primary_key => 'room_id'
end
