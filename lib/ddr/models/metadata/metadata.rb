module Ddr::Models
  module Metadata
    extend ActiveSupport::Concern

    ADMIN_METADATA = 'admin_metadata'.freeze
    DESC_METADATA  = 'desc_metadata'.freeze

    included do
      def self.property_term(term)
        property_terms[term.to_sym]
      end
    end

    def values(term)
      self.send(term)
    end

    # Update singular term with value
    def set_value(term, value)
      begin
        self.send("#{term}=", value)
      rescue NoMethodError
        raise ArgumentError, "No such term: #{term}"
      end
    end

    # Update term with values
    # Note that empty values (nil or "") are rejected from values array
    def set_values(term, values)
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
    def add_value(term, value)
      begin
        unless value.blank?
          prop_term = self.class.property_term(term)
          if object.class.properties[prop_term.to_s].multiple?
            values = values(term).to_a << value
            set_values term, values
          else
            set_value term, value
          end
        end
      rescue NoMethodError
        raise ArgumentError, "No such term: #{term}"
      end
    end

  end
end
