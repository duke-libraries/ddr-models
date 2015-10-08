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
   <archdesc level="collection">
     <did>
       <repository>
         <corpname>Library of the Perplexed</corpname>
       </repository>
       <unittitle>Perplexities</unittitle>
       <unitid>RL.00327</unitid>
       <physdesc altrender="whole">
         <extent altrender="materialtype spaceoccupied">6.5 Linear Feet</extent>
       </physdesc>
       <unitdate normal="1876/1953" type="inclusive">1876-1953</unitdate>
       <abstract>Abstract of Perplexities.</abstract>
       <physdesc id="aspace_foobar">
         <extent>4000 Items</extent>
       </physdesc>
     </did>
   </archdesc>
</ead>
EOS
    end

    before do
      allow(subject).to receive(:doc) { Nokogiri::XML(ead_xml) }
    end

    its(:title) { is_expected.to eq("Guide to the Perplexed") }
    its(:url) { is_expected.to eq("http://example.com/ead/") }
    its(:repository) { is_expected.to eq("Library of the Perplexed") }
    its(:collection_date_span) { is_expected.to eq("1876-1953") }
    its(:collection_number) { is_expected.to eq("RL.00327") }
    its(:collection_title) { is_expected.to eq("Perplexities") }
    its(:extent) { is_expected.to eq("6.5 Linear Feet; 4000 Items") }
    its(:abstract) { is_expected.to eq("Abstract of Perplexities.") }

  end
end
