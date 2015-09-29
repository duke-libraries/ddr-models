module Ddr::Models
  RSpec.describe FindingAid do

    subject { described_class.new("ead") }

    let(:ead_xml) do
      <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<ead xmlns="urn:isbn:1-931666-22-9"
     xmlns:xlink="http://www.w3.org/1999/xlink"
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xsi:schemaLocation="urn:isbn:1-931666-22-9 http://www.loc.gov/ead/ead.xsd">
   <eadheader countryencoding="iso3166-1"
              dateencoding="iso8601"
              findaidstatus="published"
              langencoding="iso639-2b"
              repositoryencoding="iso15511">
      <eadid url="http://example.com/ead/">ead</eadid>
      <filedesc>
         <titlestmt>
            <titleproper>Guide to the Perplexed
              <num>00001</num>
            </titleproper>
          </titlestmt>
      </filedesc>
   </eadheader>
</ead>
EOS
    end

    before do
      allow(subject).to receive(:doc) { Nokogiri::XML(ead_xml) }
    end

    its(:title) { is_expected.to eq("Guide to the Perplexed") }
    its(:url) { is_expected.to eq("http://example.com/ead/") }

  end
end
