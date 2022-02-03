class MatrixEvent < ActiveRecord::Base
  establish_connection :hindsight
  belongs_to :room, :primary_key => 'room_id', :class_name => "MatrixRoom"
end
