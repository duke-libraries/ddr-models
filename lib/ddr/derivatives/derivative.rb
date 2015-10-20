module Ddr::Derivatives
  class Derivative

    attr_reader :generator
    attr_accessor :workdir

    def initialize(generator)
      @generator = generator
    end

    def generate!(object)
      self.workdir = FileUtils.mkdir(File.join(Dir.tmpdir, Dir::Tmpname.make_tmpname('',nil))).first
      source_path = create_source_file(object)
      results = generator.generate(source_path, output_path(object))
      if results.status.success?
        store(object, results.output_path)
      else
        Rails.logger.error results.stderr
        raise Ddr::Models::DerivativeGenerationFailure,
                "Failure generating #{self.class.name} for #{object.id}: #{results.stderr}"
      end
      FileUtils.remove_dir(workdir)
    end

    # Whether a derivative can be generated for the object.
    # Implemented in each subclass.
    def self.generatable?(object)
      raise NotImplementedError
    end

    # Whether the object has this derivative.
    # Implemented in each subclass.
    def self.has_derivative?(object)
      raise NotImplementedError
    end

    # Delete the existing derivative
    # Implemented in each subclass.
    def delete!(object)
      raise NotImplementedError
    end

    protected

    # The path to which the generated output is written.
    # Implemented in each subclass.
    def output_path(object)
      raise NotImplementedError
    end

    # The mechanism by which the generated derivative is registered with the ActiveFedora object.
    # Implemented in each subclass.
    def store(object, output_path)
      raise NotImplementedError
    end

    private

    def create_source_file(object)
      file_path = File.join(workdir, "source")
      file = File.new(file_path, "wb")
      file.write(object.content.content)
      file.close
      file_path
    end

  end
end