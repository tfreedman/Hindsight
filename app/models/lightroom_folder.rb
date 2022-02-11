class LightroomFolder < ApplicationRecord
  establish_connection :lightroom
  self.table_name = 'AgLibraryFolder'
  has_many :files, :foreign_key => 'folder', :class_name => "LightroomFile", :primary_key => 'id_local'
  belongs_to :root_folder, :foreign_key => 'rootFolder', :class_name => "LightroomRootFolder", :primary_key => 'id_local'
end
