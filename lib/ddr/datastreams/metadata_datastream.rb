module Ddr
  module Datastreams
    class MetadataDatastream < ActiveFedora::NtriplesRDFDatastream

      def self.term_names
        properties.keys.map(&:to_sym).sort
      end

      # Returns ActiveTriplesTerm now that this is an RDF datastream
      def values term
        term == :format ? self.format : self.send(term)
      end

      # Update term with values
      # Note that empty values (nil or "") are rejected from values array
      def set_values term, values
        if values.respond_to?(:reject!)
          values.reject! { |v| v.blank? }
        else
          values = nil if values.blank?
        end
        begin
          self.send("#{term}=", values)
        rescue NoMethodError
          raise ArgumentError, "No such term: #{term}"
        end
      end

      # Add value to term
      # Note that empty value (nil or "") is not added
      def add_value term, value
        begin
          unless value.blank?
            values = values(term).to_a << value
            set_values term, values
          end
        rescue NoMethodError
          raise ArgumentError, "No such term: #{term}"
        end
      end

      def content_changed?
        # Patches a bug in AF RDF datastreams where
        # Content appears to change from nil to empty string
        super && !empty?
      end

    end
  end
end
