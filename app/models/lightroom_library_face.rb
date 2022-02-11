class LightroomLibraryFace < ApplicationRecord
  establish_connection :lightroom
  self.table_name = 'AgLibraryFace'

  belongs_to :image, :foreign_key => 'image', :class_name => "LightroomImage", :primary_key => 'id_local'
  belongs_to :lightroom_keyword_face, :foreign_key => 'id_local', :class_name => "LightroomKeywordFace", :primary_key => 'face'
end
