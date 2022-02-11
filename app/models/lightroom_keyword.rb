class LightroomKeyword < ApplicationRecord
  establish_connection :lightroom
  self.table_name = 'AgLibraryKeyword'

  has_many :faces, :foreign_key => 'tag', :class_name => "LightroomKeywordFace", :primary_key => 'id_local'

  def images
    paths = []
    x = self.faces.pluck(:face)
    LightroomLibraryFace.where(id_local: x).find_each do |face|
      paths << face.image.file.absolute_path
    end
    return paths
  end
end
