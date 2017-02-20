module Ddr::Datastreams
  class ExternalFileDatastream < ActiveFedora::Datastream

    FILE_PERMISSIONS = 0644

    class_attribute :file_store

    around_destroy :delete_file!

    def self.default_attributes
      super.merge(controlGroup: "E")
    end

    def file_size
      File.size(file_path) if file_path
    end

    def add_file(source_path, mime_type: nil)
      set_mime_type(source_path, mime_type)
      store(source_path)
    end

    def file_path
      Ddr::Utils.path_from_uri(dsLocation) if dsLocation
    end

    def file_path=(path)
      self.dsLocation = Ddr::Utils.path_to_uri(path)
    end

    def generate_file_name
      SecureRandom.uuid
    end

    def generate_stored_path
      file_name = generate_file_name
      subpath = File.join([0, 2, 4, 6].map { |i| file_name[i, 2] })
      File.join(file_store, subpath, file_name)
    end

    def file_paths
      new? ? Array(file_path) : versions.map(&:file_path)
    end

    private

    def store(source_path)
      stored_path = generate_stored_path
      FileUtils.mkdir_p File.dirname(stored_path)
      FileUtils.cp source_path, stored_path
      File.chmod(FILE_PERMISSIONS, stored_path)
      self.file_path = stored_path
    end

    def set_mime_type(source_path, mime_type = nil)
      self.mimeType = mime_type || get_mime_type(source_path)
    end

    def get_mime_type(source_path)
      mime_types = MIME::Types.of(source_path)
      mime_types.empty? ? Ddr::Models.default_mime_type : mime_types.first.content_type
    end

    def delete_file!
      path = file_path
      yield
      FileUtils.rm_f(path)
    end

  end
end
