module Ddr::Derivatives
  class Thumbnail < Derivative

    def self.generatable?(object)
      object.can_have_thumbnail? && object.has_content? && object.image?
    end

    def self.has_derivative?(object)
      object.has_thumbnail?
    end

    def delete!(object)
      object.thumbnail.content = ''
      object.save
    end

    protected

    def output_path(object)
      File.join(workdir, output_file_name(object))
    end

    def output_file_name(object)
      basename = object.content.original_name.present? ? File.basename(object.content.original_name, '.*') : "thumbnail"
      "#{basename}.#{generator.class.output_extension}"
    end

    def store(object, output_path)
      output_file = File.open(output_path, 'rb')
      object.reload if object.persisted?
      object.add_file output_file, path: Ddr::Models::File::THUMBNAIL, mime_type: generator.class.output_mime_type
      object.save!
    end

  end
end
