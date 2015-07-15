require 'spec_helper'

def simple_structure_document
  Nokogiri::XML(simple_structure) do |config|
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
        <div ORDER="1">
          <fptr CONTENTIDS="info:fedora/test:6" />
        </div>
        <div ORDER="2">
          <fptr CONTENTIDS="info:fedora/test:5" />
        </div>
        <div ORDER="3">
          <fptr CONTENTIDS="info:fedora/test:7" />
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
          <fptr CONTENTIDS="info:fedora/test:5" />
        </div>
        <div ORDER="2" LABEL="Back">
          <div ORDER="1" LABEL="Top">
            <fptr CONTENTIDS="info:fedora/test:7" />
          </div>    
          <div ORDER="2" LABEL="Bottom">
            <fptr CONTENTIDS="info:fedora/test:6" />
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
          <fptr CONTENTIDS="info:fedora/test:5" />
        </div>
        <div ORDER="2" LABEL="Back">
          <div ORDER="1" LABEL="Top">
            <fptr CONTENTIDS="info:fedora/test:7" />
          </div>    
          <div ORDER="2" LABEL="Bottom">
            <fptr CONTENTIDS="info:fedora/test:6" />
          </div>    
        </div>
      </structMap>
      <structMap TYPE="reverse">
        <div ORDER="1" LABEL="Back">
          <div ORDER="1" LABEL="Bottom">
            <fptr CONTENTIDS="info:fedora/test:6" />
          </div>
          <div ORDER="2" LABEL="Top">
            <fptr CONTENTIDS="info:fedora/test:7" />
          </div>    
        </div>
        <div ORDER="2" LABEL="Front">
          <fptr CONTENTIDS="info:fedora/test:5" />
        </div>
      </structMap>
    </mets>
  eos
end

def simple_structure_query_response
  [{"system_create_dtsi"=>"2015-06-17T21:04:24Z", "system_modified_dtsi"=>"2015-06-17T21:04:56Z", "object_state_ssi"=>"A", "active_fedora_model_ssi"=>"Component", "id"=>"test:6", "object_profile_ssm"=>["{\"datastreams\":{\"RELS-EXT\":{\"dsLabel\":\"Fedora Object-to-Object Relationship Metadata\",\"dsVersionID\":\"RELS-EXT.1\",\"dsCreateDate\":\"2015-06-17T21:04:56Z\",\"dsState\":\"A\",\"dsMIME\":\"application/rdf+xml\",\"dsFormatURI\":null,\"dsControlGroup\":\"X\",\"dsSize\":408,\"dsVersionable\":true,\"dsInfoType\":null,\"dsLocation\":\"test:6+RELS-EXT+RELS-EXT.1\",\"dsLocationType\":null,\"dsChecksumType\":\"SHA-256\",\"dsChecksum\":\"bf84faa89d6b25924bc06357f7c33347a602e2ec8df9c1020ec98015fe571760\"},\"descMetadata\":{\"dsLabel\":\"Descriptive Metadata for this object\",\"dsVersionID\":\"descMetadata.1\",\"dsCreateDate\":\"2015-06-17T21:04:56Z\",\"dsState\":\"A\",\"dsMIME\":\"application/n-triples\",\"dsFormatURI\":null,\"dsControlGroup\":\"M\",\"dsSize\":70,\"dsVersionable\":true,\"dsInfoType\":null,\"dsLocation\":\"test:6+descMetadata+descMetadata.1\",\"dsLocationType\":\"INTERNAL_ID\",\"dsChecksumType\":\"SHA-256\",\"dsChecksum\":\"4d227bc972634ba2126eefff207fb3b35f6ff802a210ad7945d2ec60360076dd\"},\"rightsMetadata\":{},\"properties\":{},\"thumbnail\":{},\"adminMetadata\":{},\"content\":{},\"extractedText\":{},\"multiresImage\":{},\"structMetadata\":{}},\"objLabel\":null,\"objOwnerId\":\"fedoraAdmin\",\"objModels\":[\"info:fedora/fedora-system:FedoraObject-3.0\"],\"objCreateDate\":\"2015-06-17T21:04:24Z\",\"objLastModDate\":\"2015-06-17T21:04:24Z\",\"objDissIndexViewURL\":\"http://localhost:8983/fedora/objects/test%3A6/methods/fedora-system%3A3/viewMethodIndex\",\"objItemIndexViewURL\":\"http://localhost:8983/fedora/objects/test%3A6/methods/fedora-system%3A3/viewItemIndex\",\"objState\":\"A\"}"], "identifier_tesim"=>["abc001"], "is_part_of_ssim"=>["info:fedora/test:2"], "has_model_ssim"=>["info:fedora/afmodel:Component"], "title_ssi"=>"abc001", "internal_uri_ssi"=>"info:fedora/test:6", "identifier_ssi"=>"abc001", "access_role_ssi"=>"[]", "_version_"=>1504261016868880384, "timestamp"=>"2015-06-17T21:04:56.958Z"}, {"system_create_dtsi"=>"2015-06-17T21:03:58Z", "system_modified_dtsi"=>"2015-06-17T21:04:54Z", "object_state_ssi"=>"A", "active_fedora_model_ssi"=>"Component", "id"=>"test:5", "object_profile_ssm"=>["{\"datastreams\":{\"RELS-EXT\":{\"dsLabel\":\"Fedora Object-to-Object Relationship Metadata\",\"dsVersionID\":\"RELS-EXT.1\",\"dsCreateDate\":\"2015-06-17T21:04:54Z\",\"dsState\":\"A\",\"dsMIME\":\"application/rdf+xml\",\"dsFormatURI\":null,\"dsControlGroup\":\"X\",\"dsSize\":408,\"dsVersionable\":true,\"dsInfoType\":null,\"dsLocation\":\"test:5+RELS-EXT+RELS-EXT.1\",\"dsLocationType\":null,\"dsChecksumType\":\"SHA-256\",\"dsChecksum\":\"6a7f1cbe6e435991ae3bba134e52e7a275af8a232b209ac725fa54fdd81bb973\"},\"descMetadata\":{\"dsLabel\":\"Descriptive Metadata for this object\",\"dsVersionID\":\"descMetadata.1\",\"dsCreateDate\":\"2015-06-17T21:04:54Z\",\"dsState\":\"A\",\"dsMIME\":\"application/n-triples\",\"dsFormatURI\":null,\"dsControlGroup\":\"M\",\"dsSize\":70,\"dsVersionable\":true,\"dsInfoType\":null,\"dsLocation\":\"test:5+descMetadata+descMetadata.1\",\"dsLocationType\":\"INTERNAL_ID\",\"dsChecksumType\":\"SHA-256\",\"dsChecksum\":\"8b106726ca2d39d9a2e187fc9da2e58b25bd3553031012515ae31cf4fbe520e9\"},\"rightsMetadata\":{},\"properties\":{},\"thumbnail\":{},\"adminMetadata\":{},\"content\":{},\"extractedText\":{},\"multiresImage\":{},\"structMetadata\":{}},\"objLabel\":null,\"objOwnerId\":\"fedoraAdmin\",\"objModels\":[\"info:fedora/fedora-system:FedoraObject-3.0\"],\"objCreateDate\":\"2015-06-17T21:03:58Z\",\"objLastModDate\":\"2015-06-17T21:03:58Z\",\"objDissIndexViewURL\":\"http://localhost:8983/fedora/objects/test%3A5/methods/fedora-system%3A3/viewMethodIndex\",\"objItemIndexViewURL\":\"http://localhost:8983/fedora/objects/test%3A5/methods/fedora-system%3A3/viewItemIndex\",\"objState\":\"A\"}"], "identifier_tesim"=>["abc002"], "is_part_of_ssim"=>["info:fedora/test:2"], "has_model_ssim"=>["info:fedora/afmodel:Component"], "title_ssi"=>"abc002", "internal_uri_ssi"=>"info:fedora/test:5", "identifier_ssi"=>"abc002", "access_role_ssi"=>"[]", "_version_"=>1504261014501195776, "timestamp"=>"2015-06-17T21:04:54.701Z"}, {"system_create_dtsi"=>"2015-06-17T21:04:46Z", "system_modified_dtsi"=>"2015-06-17T21:04:59Z", "object_state_ssi"=>"A", "active_fedora_model_ssi"=>"Component", "id"=>"test:7", "object_profile_ssm"=>["{\"datastreams\":{\"RELS-EXT\":{\"dsLabel\":\"Fedora Object-to-Object Relationship Metadata\",\"dsVersionID\":\"RELS-EXT.1\",\"dsCreateDate\":\"2015-06-17T21:04:59Z\",\"dsState\":\"A\",\"dsMIME\":\"application/rdf+xml\",\"dsFormatURI\":null,\"dsControlGroup\":\"X\",\"dsSize\":408,\"dsVersionable\":true,\"dsInfoType\":null,\"dsLocation\":\"test:7+RELS-EXT+RELS-EXT.1\",\"dsLocationType\":null,\"dsChecksumType\":\"SHA-256\",\"dsChecksum\":\"cb385ff9a55b5fe24e8c2a8159fc928e3ee582ef312955132d34282676102a6a\"},\"descMetadata\":{\"dsLabel\":\"Descriptive Metadata for this object\",\"dsVersionID\":\"descMetadata.1\",\"dsCreateDate\":\"2015-06-17T21:04:59Z\",\"dsState\":\"A\",\"dsMIME\":\"application/n-triples\",\"dsFormatURI\":null,\"dsControlGroup\":\"M\",\"dsSize\":70,\"dsVersionable\":true,\"dsInfoType\":null,\"dsLocation\":\"test:7+descMetadata+descMetadata.1\",\"dsLocationType\":\"INTERNAL_ID\",\"dsChecksumType\":\"SHA-256\",\"dsChecksum\":\"523ee1e5d55d188bd17b2789e4c9109c8f9d0170b63af1219de8a74d4f32966a\"},\"rightsMetadata\":{},\"properties\":{},\"thumbnail\":{},\"adminMetadata\":{},\"content\":{},\"extractedText\":{},\"multiresImage\":{},\"structMetadata\":{}},\"objLabel\":null,\"objOwnerId\":\"fedoraAdmin\",\"objModels\":[\"info:fedora/fedora-system:FedoraObject-3.0\"],\"objCreateDate\":\"2015-06-17T21:04:46Z\",\"objLastModDate\":\"2015-06-17T21:04:46Z\",\"objDissIndexViewURL\":\"http://localhost:8983/fedora/objects/test%3A7/methods/fedora-system%3A3/viewMethodIndex\",\"objItemIndexViewURL\":\"http://localhost:8983/fedora/objects/test%3A7/methods/fedora-system%3A3/viewItemIndex\",\"objState\":\"A\"}"], "identifier_tesim"=>["abc003"], "is_part_of_ssim"=>["info:fedora/test:2"], "has_model_ssim"=>["info:fedora/afmodel:Component"], "title_ssi"=>"abc003", "internal_uri_ssi"=>"info:fedora/test:7", "identifier_ssi"=>"abc003", "access_role_ssi"=>"[]", "_version_"=>1504261019487174656, "timestamp"=>"2015-06-17T21:04:59.455Z"}]
end

def simple_structure_to_json
  j = <<-eos
    {\"default\":
      {\"type\":\"default\",
        \"divs\":[{\"order\":\"1\",\"fptrs\":[\"test:6\"],\"divs\":[]},
                  {\"order\":\"2\",\"fptrs\":[\"test:5\"],\"divs\":[]},
                  {\"order\":\"3\",\"fptrs\":[\"test:7\"],\"divs\":[]}
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
        \"divs\":[{\"label\":\"Front\",\"order\":\"1\",\"fptrs\":[\"test:5\"],\"divs\":[]},
                  {\"label\":\"Back\",\"order\":\"2\",\"fptrs\":[],
                    \"divs\":[{\"label\":\"Top\",\"order\":\"1\",\"fptrs\":[\"test:7\"],\"divs\":[]},
                              {\"label\":\"Bottom\",\"order\":\"2\",\"fptrs\":[\"test:6\"],\"divs\":[]}
                             ]
                  }
                 ]
      },
     \"reverse\":
      {\"type\":\"reverse\",
        \"divs\":[{\"label\":\"Back\",\"order\":\"1\",\"fptrs\":[],
                    \"divs\":[{\"label\":\"Bottom\",\"order\":\"1\",\"fptrs\":[\"test:6\"],\"divs\":[]},
                              {\"label\":\"Top\",\"order\":\"2\",\"fptrs\":[\"test:7\"],\"divs\":[]}
                             ]
                  },
                  {\"label\":\"Front\",\"order\":\"2\",\"fptrs\":[\"test:5\"],\"divs\":[]}
                 ]
      }
    }    
  eos
  j.gsub(/\s+/, "")
end