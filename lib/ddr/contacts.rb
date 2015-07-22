module Ddr
  module Contacts
    extend ActiveSupport::Autoload

    class << self
      attr_accessor :contacts
    end

    def self.get(contact_slug)
      load_contacts unless contacts
      contacts[contact_slug]
    end

    def self.load_contacts
      self.contacts = OpenStruct.new
      contacts_file = File.join(Rails.root, 'config', 'contacts.yml')
      YAML.load_file(contacts_file).each do |key, value|
        contacts[key] = OpenStruct.new(value.merge('slug' => key))
      end
    rescue SystemCallError
      Rails.logger.warn("Unable to load Contacts file: #{contacts_file}")
    end

  end
end