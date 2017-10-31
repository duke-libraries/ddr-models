require 'digest'

module Ddr::Datastreams
  class ExternalFileDatastream < ActiveFedora::Datastream

    FILE_PERMISSIONS = 0644

    class_attribute :file_store

    after_destroy do
      self.dsLocation = nil # Rubydora does not reset dsLocation
    end

    def self.default_attributes
      super.merge(controlGroup: "E")
    end

    def content
      external? && !new? ? File.read(file_path) : super
    end

    def file_size
      if path = file_path
        File.size(path)
      end
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

    def content_digest(algorithm=Ddr::Datastreams::CHECKSUM_TYPE_SHA1)
      digest_class = Digest.const_get(algorithm.sub("-", ""))
      digest_class.file(file_path).hexdigest
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

  end
end
