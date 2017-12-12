module Ddr::Models::Structures
  class ComponentTypeTerm

    CONFIG_FILE = ::File.join(Rails.root, 'config', 'structure_component_type.yml')

    @@lookup = {}

    def self.term(media_type)
      hit = lookup_table.detect { |k,v| media_type =~ k }
      hit.last if hit
    end

    def self.lookup_table
      load_lookup if @@lookup.empty?
      @@lookup
    end

    def self.load_lookup
      config = YAML::load(::File.read(CONFIG_FILE))
      config.each do |type_term, media_types|
        media_types.each do |media_type|
          lookup_key = Regexp.new("\\A#{media_type.gsub('*', '.*')}\\Z")
          @@lookup[lookup_key] = type_term
        end
      end
    end

  end
end
