require 'spec_helper'

module Ddr
  RSpec.describe Contacts, contacts: true do

    before do
      allow(YAML).to receive(:load_file) { { 'a' => { 'name' => 'Contact A', 'short_name' => 'A' },
                                             'b' => { 'name' => 'Contact B', 'short_name' => 'B' } } }
      Contacts.load_contacts
    end

    describe "load_contacts" do
      it "should load the contacts" do
        expect(Contacts.contacts.to_h).to_not be_empty
      end
    end

    describe "get" do
      it "should return the appropriate contact" do
        expect(Contacts.get('a').name).to eq('Contact A')
        expect(Contacts.get('b').name).to eq('Contact B')
      end
    end

  end
end
