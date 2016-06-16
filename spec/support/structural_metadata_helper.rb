require 'spec_helper'

def simple_structure_document
  Nokogiri::XML(simple_structure) do |config|
    config.noblanks
  end
end

def simple_structure_document_without_local_id
  Nokogiri::XML(simple_structure_without_local_id) do |config|
    config.noblanks
  end
end

def nested_structure_document
  Nokogiri::XML(nested_structure) do |config|
    config.noblanks
  end
end

def multiple_struct_maps_structure_document
  Nokogiri::XML(multiple_struct_maps_structure) do |config|
    config.noblanks
  end
end

def simple_structure
  <<-eos
    <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink">
      <structMap TYPE="default">
        <div ID="abc001" ORDER="1">
          <fptr CONTENTIDS="test_6" />
        </div>
        <div ID="abc002" ORDER="2">
          <fptr CONTENTIDS="test_5" />
        </div>
        <div ID="abc003" ORDER="3">
          <fptr CONTENTIDS="test_7" />
        </div>
      </structMap>
    </mets>
  eos
end

def simple_structure_without_local_id
  <<-eos
    <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink">
      <structMap TYPE="default">
        <div ORDER="1">
          <fptr CONTENTIDS="test_6" />
        </div>
        <div ORDER="2">
          <fptr CONTENTIDS="test_5" />
        </div>
        <div ORDER="3">
          <fptr CONTENTIDS="test_7" />
        </div>
      </structMap>
    </mets>
  eos
end

def nested_structure
  <<-eos
    <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink">
      <structMap TYPE="default">
        <div ORDER="1" LABEL="Front">
          <fptr CONTENTIDS="test_5" />
        </div>
        <div ORDER="2" LABEL="Back">
          <div ORDER="1" LABEL="Top">
            <fptr CONTENTIDS="test_7" />
          </div>
          <div ORDER="2" LABEL="Bottom">
            <fptr CONTENTIDS="test_6" />
          </div>
        </div>
      </structMap>
    </mets>
  eos
end

def multiple_struct_maps_structure
  <<-eos
    <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink">
      <structMap TYPE="default">
        <div ORDER="1" LABEL="Front">
          <fptr CONTENTIDS="test_5" />
        </div>
        <div ORDER="2" LABEL="Back">
          <div ORDER="1" LABEL="Top">
            <fptr CONTENTIDS="test_7" />
          </div>
          <div ORDER="2" LABEL="Bottom">
            <fptr CONTENTIDS="test_6" />
          </div>
        </div>
      </structMap>
      <structMap TYPE="reverse">
        <div ORDER="1" LABEL="Back">
          <div ORDER="1" LABEL="Bottom">
            <fptr CONTENTIDS="test_6" />
          </div>
          <div ORDER="2" LABEL="Top">
            <fptr CONTENTIDS="test_7" />
          </div>
        </div>
        <div ORDER="2" LABEL="Front">
          <fptr CONTENTIDS="test_5" />
        </div>
      </structMap>
    </mets>
  eos
end

def simple_structure_query_response
  [ { "id"=>"test_6", "local_id_ssi"=>"abc001"  }, { "id"=>"test_5", "local_id_ssi"=>"abc002" }, { "id"=>"test_7", "local_id_ssi"=>"abc003" } ]
end

def simple_structure_without_local_id_query_response
  [ { "id"=>"test_6", "system_create_dtsi" => "2016-05-23T13:02:07Z" }, { "id"=>"test_5", "system_create_dtsi" => "2016-05-23T13:02:09Z" }, { "id"=>"test_7", "system_create_dtsi" => "2016-05-23T13:02:12Z" } ]
end

def simple_structure_to_json
  j = <<-eos
    {\"default\":
      {\"type\":\"default\",
        \"divs\":[{\"id\":\"abc001\",\"order\":\"1\",\"fptrs\":[\"test_6\"],\"divs\":[]},
                  {\"id\":\"abc002\",\"order\":\"2\",\"fptrs\":[\"test_5\"],\"divs\":[]},
                  {\"id\":\"abc003\",\"order\":\"3\",\"fptrs\":[\"test_7\"],\"divs\":[]}
                 ]
      }
    }
  eos
  j.gsub(/\s+/, "")
end

def multiple_struct_maps_structure_to_json
  j = <<-eos
    {\"default\":
      {\"type\":\"default\",
        \"divs\":[{\"label\":\"Front\",\"order\":\"1\",\"fptrs\":[\"test_5\"],\"divs\":[]},
                  {\"label\":\"Back\",\"order\":\"2\",\"fptrs\":[],
                    \"divs\":[{\"label\":\"Top\",\"order\":\"1\",\"fptrs\":[\"test_7\"],\"divs\":[]},
                              {\"label\":\"Bottom\",\"order\":\"2\",\"fptrs\":[\"test_6\"],\"divs\":[]}
                             ]
                  }
                 ]
      },
     \"reverse\":
      {\"type\":\"reverse\",
        \"divs\":[{\"label\":\"Back\",\"order\":\"1\",\"fptrs\":[],
                    \"divs\":[{\"label\":\"Bottom\",\"order\":\"1\",\"fptrs\":[\"test_6\"],\"divs\":[]},
                              {\"label\":\"Top\",\"order\":\"2\",\"fptrs\":[\"test_7\"],\"divs\":[]}
                             ]
                  },
                  {\"label\":\"Front\",\"order\":\"2\",\"fptrs\":[\"test_5\"],\"divs\":[]}
                 ]
      }
    }
  eos
  j.gsub(/\s+/, "")
end
