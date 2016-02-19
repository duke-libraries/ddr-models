module Ddr::Derivatives
  class MultiresImage < Derivative

    def self.generatable?(object)
      object.can_have_multires_image? &&
          object.has_content? &&
          (object.content_type == "image/tiff" || object.content_type == "image/jpeg")
    end

    def self.has_derivative?(object)
      object.has_multires_image?
    end

    def delete!(object)
      object.multires_image_file_path = nil
      object.save
    end

    protected

    def output_path(object)
      File.join(create_external_file_path!, output_file_name(object))
    end

    def output_file_name(object)
      basename = object.content.original_name.present? ? File.basename(object.content.original_name, '.*') : "multires_image"
      "#{basename}.#{generator.class.output_extension}"
    end

    def store(object, output_path)
      object.multires_image_file_path = output_path
      object.save!
    end

    private

    def create_external_file_path!
      file_path = generate_external_file_path
      FileUtils.mkdir_p(file_path)
      file_path
    end

    #
    # Generates a new external file storage location
    #
    # => {external_file_store}/1/e/69/1e691815-0631-4f9b-8e23-2dfb2eec9c70
    #
    def generate_external_file_path
      File.join(Ddr::Models.multires_image_external_file_store, generate_external_directory_subpath)
    end

    def generate_external_directory_subpath
      subdir = SecureRandom.uuid
      m = Ddr::Models.external_file_subpath_regexp.match(subdir)
      raise "File name does not match external file subpath pattern: #{file_name}" unless m
      subpath_segments = m.to_a[1..-1]
      File.join *subpath_segments, subdir
    end

  end
end
