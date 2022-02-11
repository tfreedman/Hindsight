class LightroomKeywordFace < ApplicationRecord
  establish_connection :lightroom
  self.table_name = 'AgLibraryKeywordFace'
  default_scope { where(userPick: 1) }

  has_many :entries, :foreign_key => 'id_local', :class_name => "LightroomLibraryFace", :primary_key => 'face'

  belongs_to :lightroom_keyword, :foreign_key => 'tag', :class_name => "LightroomKeyword", :primary_key => 'id_local'
end
