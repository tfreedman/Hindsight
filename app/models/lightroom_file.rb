class LightroomFile < ApplicationRecord
  establish_connection :lightroom
  self.table_name = 'AgLibraryFile'
  belongs_to :folder, :foreign_key => 'folder', :class_name => "LightroomFolder", :primary_key => 'id_local'
  belongs_to :image, :foreign_key => 'id_local', :class_name => "LightroomImage", :primary_key => 'rootFile'

  def absolute_path
    return self.folder.root_folder.server_path + self.folder.pathFromRoot + self.idx_filename
  end
end
