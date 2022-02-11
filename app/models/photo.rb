class Photo < ActiveRecord::Base
  establish_connection :hindsight

  def lightroom_rating
    if self.lightroom_image
      return self.lightroom_image.rating
    end
    return nil
  end

  def lightroom_phototags
    if self.lightroom_image
      faces = []
      self.lightroom_image.faces.each do |face|
        if face.lightroom_keyword_face && face.lightroom_keyword_face.lightroom_keyword
          faces << face.lightroom_keyword_face.lightroom_keyword.name
        end
      end
      return faces
    end
    return nil
  end

  def lightroom_image
    if self.lightroom_file
      return self.lightroom_file.image
    end
    return nil
  end

  def lightroom_file
    LightroomRootFolder.find_each do |root_folder|
      if self[:path].start_with?(root_folder.server_path)
        relative_folder = Pathname(self[:path].split(root_folder.server_path)[1]).dirname.to_s + '/'
        lrfolder = root_folder.folders.where(pathFromRoot: relative_folder).first
        return lrfolder.files.where(basename: File.basename(self[:path], File.extname(self[:path]))).first
      end
    end
  end

  def lightroom_export
    if self.lightroom_rating && self.lightroom_rating >= 4.0
      export_filename = self.path
      Rails.application.credentials.config[:lightroom_export_paths].each do |item|
        export_filename = export_filename.gsub(item[:find], item[:replace])
      end
      export_filename = Pathname(export_filename).dirname.to_s + '/' + File.basename(export_filename, File.extname(export_filename)) + '.jpg'
      if File.file?(export_filename)
        return export_filename
      end
    end
    return nil
  end

  def is_sidecar?
    file = self.lightroom_file
    $file = file
    if file.nil?
      return false
    elsif file
      extension = File.basename(self[:path]).split('.')[1]
      if file.extension == extension
        return false
      elsif file.sidecarExtensions.include?(extension)
        return true
      end
    end
  end
end
