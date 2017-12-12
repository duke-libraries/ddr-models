module Ddr
  module Datastreams
    class MetadataDatastream < ActiveFedora::NtriplesRDFDatastream

      # ASCII control chars, except newline
      ILLEGAL_CHARS = Regexp.new('[\x00-\x09\x0B-\x1F]')

      def self.term_names
        properties.keys.map(&:to_sym).sort
      end

      # Returns ActiveTriplesTerm now that this is an RDF datastream
      def values(term)
        term == :format ? self.format : self.send(term)
      end

      # Update term with values
      # Note that empty values (nil or "") are rejected from values array
      def set_values(term, values)
        vals = Array(values)
               .map    { |v| sanitize_value(v) }
               .reject { |v| reject_value?(v)  }
        begin
          self.send("#{term}=", vals)
        rescue NoMethodError
          raise ArgumentError, "No such term: #{term}"
        end
      end

      # Add value to term
      # Note that empty value (nil or "") is not added
      def add_value(term, value)
        vals = values(term).to_a << value
        set_values(term, vals)
      end

      def content_changed?
        # Patches a bug in AF RDF datastreams where
        # Content appears to change from nil to empty string
        super && !empty?
      end

      private

      def sanitize_value(value)
        value
          .to_s
          .strip
          .gsub(ILLEGAL_CHARS, "")
      end

      def reject_value?(value)
        value.blank?
      end

    end
  end
end
