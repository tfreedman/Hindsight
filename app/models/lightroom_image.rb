class LightroomImage < ApplicationRecord
  establish_connection :lightroom
  self.table_name = 'Adobe_images'

  belongs_to :file, :foreign_key => 'rootFile', :class_name => "LightroomFile", :primary_key => 'id_local'
  has_many :faces, :foreign_key => 'image', :class_name => "LightroomLibraryFace", :primary_key => 'id_local'

  def timestamp
    photo = Photo.where(path: self.file.absolute_path).first
    if photo
      return photo.timestamp 
    else
      return nil
    end
  end

  def coordinates
    photo = Photo.where(path: self.file.absolute_path).first
    if photo
      return photo.coordinates
    else
      return nil
    end
  end
end
