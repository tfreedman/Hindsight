class LightroomRootFolder < ApplicationRecord
  establish_connection :lightroom
  self.table_name = 'AgLibraryRootFolder'
  has_many :folders, :foreign_key => 'rootFolder', :class_name => "LightroomFolder", :primary_key => 'id_local'

  def server_path
    Rails.application.credentials.config[:lightroom_replacement_root_paths].each do |item|
      if self.id_local == item[:id_local]
        return item[:replacement_path]
      else
        return self[:absolutePath]
      end
    end
  end
end
