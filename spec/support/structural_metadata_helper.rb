require 'spec_helper'

def simple_structure_document
  Nokogiri::XML(simple_structure_xml) do |config|
    config.noblanks
  end
end

def nested_structure_document
  Nokogiri::XML(nested_structure_xml) do |config|
    config.noblanks
  end
end

def nested_structure_mptr_document
  Nokogiri::XML(nested_structure_mptr_xml) do |config|
    config.noblanks
  end
end

def multiple_struct_maps_structure_document
  Nokogiri::XML(multiple_struct_maps_structure) do |config|
    config.noblanks
  end
end

def simple_structure_xml
  <<-eos
    <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink">
      <metsHdr>
        <agent ROLE="CREATOR">
          <name>#{Ddr::Models::Structures::Agent::NAME_REPOSITORY_DEFAULT}</name>
        </agent>
      </metsHdr>
      <fileSec>
        <fileGrp>
          <file ID="abc" USE="foo">
            <FLocat LOCTYPE="ARK" xlink:href="ark:/99999/fk4ab3" />
          </file>
          <file ID="def" USE="bar">
            <FLocat LOCTYPE="ARK" xlink:href="ark:/99999/fk4cd9" />
          </file>
          <file ID="ghi" USE="baz">
            <FLocat LOCTYPE="ARK" xlink:href="ark:/99999/fk4ef1" />
          </file>
        </fileGrp>
      </fileSec>
      <structMap TYPE="default">
        <div ORDER="1">
          <fptr FILEID="abc" />
        </div>
        <div ORDER="2">
          <fptr FILEID="def" />
        </div>
        <div ORDER="3">
          <fptr FILEID="ghi" />
        </div>
      </structMap>
    </mets>
  eos
end

def nested_structure_xml
  <<-eos
    <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink">
      <metsHdr>
        <agent ROLE="CREATOR">
          <name>Sam Spade</name>
        </agent>
      </metsHdr>
      <fileSec>
        <fileGrp>
          <file ID="abc" USE="foo">
            <FLocat LOCTYPE="ARK" xlink:href="ark:/99999/fk4ab3" />
          </file>
          <file ID="def" USE="bar">
            <FLocat LOCTYPE="ARK" xlink:href="ark:/99999/fk4cd9" />
          </file>
          <file ID="ghi" USE="baz">
            <FLocat LOCTYPE="ARK" xlink:href="ark:/99999/fk4ef1" />
          </file>
        </fileGrp>
      </fileSec>
      <structMap TYPE="default">
        <div ORDER="1" LABEL="Front">
          <fptr FILEID="abc" />
        </div>
        <div ORDER="2" LABEL="Back">
          <div ORDER="1" LABEL="Top">
            <fptr FILEID="def" />
          </div>
          <div ORDER="2" LABEL="Bottom">
            <fptr FILEID="ghi" />
          </div>
        </div>
      </structMap>
    </mets>
  eos
end

def nested_structure_mptr_xml
  <<-eos
    <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink">
      <metsHdr>
        <agent ROLE="CREATOR">
          <name>Sam Spade</name>
        </agent>
      </metsHdr>
      <structMap TYPE="default">
        <div ORDER="1" LABEL="Front">
          <mptr LOCTYPE="ARK" xlink:href="ark:/99999/fk4ab3" />
        </div>
        <div ORDER="2" LABEL="Back">
          <div ORDER="1" LABEL="Top">
            <mptr LOCTYPE="ARK" xlink:href="ark:/99999/fk4cd9" />
          </div>
          <div ORDER="2" LABEL="Bottom">
            <mptr LOCTYPE="ARK" xlink:href="ark:/99999/fk4ef1" />
          </div>
        </div>
      </structMap>
    </mets>
  eos
end

def multiple_struct_maps_structure
  <<-eos
    <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink">
      <fileSec>
        <fileGrp>
          <file ID="abc" USE="foo">
            <FLocat LOCTYPE="ARK" xlink:href="ark:/99999/fk4ab3" />
          </file>
          <file ID="def" USE="bar">
            <FLocat LOCTYPE="ARK" xlink:href="ark:/99999/fk4cd9" />
          </file>
          <file ID="ghi" USE="baz">
            <FLocat LOCTYPE="ARK" xlink:href="ark:/99999/fk4ef1" />
          </file>
        </fileGrp>
      </fileSec>
      <structMap TYPE="default">
        <div ORDER="1" LABEL="Front">
          <fptr FILEID="abc" />
        </div>
        <div ORDER="2" LABEL="Back">
          <div ORDER="1" LABEL="Top">
            <fptr FILEID="def" />
          </div>
          <div ORDER="2" LABEL="Bottom">
            <fptr FILEID="ghi" />
          </div>
        </div>
      </structMap>
      <structMap TYPE="reverse">
        <div ORDER="1" LABEL="Back">
          <div ORDER="1" LABEL="Bottom">
            <fptr FILEID="ghi" />
          </div>
          <div ORDER="2" LABEL="Top">
            <fptr FILEID="def" />
          </div>
        </div>
        <div ORDER="2" LABEL="Front">
          <fptr FILEID="abc" />
        </div>
      </structMap>
    </mets>
  eos
end

def simple_structure_dereferenced_hash
  yaml = <<-eos
    default:
      :type: 'default'
      :contents:
        - :order: '1'
          :contents:
            - :repo_id: 'test:7'
              :use: 'foo'
        - :order: '2'
          :contents:
            - :repo_id: 'test:8'
              :use: 'bar'
        - :order: '3'
          :contents:
            - :repo_id: 'test:9'
              :use: 'baz'
  eos
  YAML.load(yaml)
end

def nested_structure_dereferenced_hash
  yaml = <<-eos
    default:
      :type: 'default'
      :contents:
        - :label: 'Front'
          :order: '1'
          :contents:
            - :repo_id: 'test:7'
              :use: 'foo'
        - :label: 'Back'
          :order: '2'
          :contents:
            - :label: 'Top'
              :order: '1'
              :contents:
                - :repo_id: 'test:8'
                  :use: 'bar'
            - :label: 'Bottom'
              :order: '2'
              :contents:
                - :repo_id: 'test:9'
                  :use: 'baz'
  eos
  YAML.load(yaml)
end

def nested_structure_mptr_dereferenced_hash
  yaml = <<-eos
    default:
      :type: 'default'
      :contents:
        - :label: 'Front'
          :order: '1'
          :contents:
            - :repo_id: 'test:7'
        - :label: 'Back'
          :order: '2'
          :contents:
            - :label: 'Top'
              :order: '1'
              :contents:
                - :repo_id: 'test:8'
            - :label: 'Bottom'
              :order: '2'
              :contents:
                - :repo_id: 'test:9'
  eos
  YAML.load(yaml)
end

def multiple_struct_maps_structure_dereferenced_hash
  yaml = <<-eos
    default:
      :type: 'default'
      :contents:
        - :label: 'Front'
          :order: '1'
          :contents:
            - :repo_id: 'test:7'
              :use: 'foo'
        - :label: 'Back'
          :order: '2'
          :contents:
            - :label: 'Top'
              :order: '1'
              :contents:
                - :repo_id: 'test:8'
                  :use: 'bar'
            - :label: 'Bottom'
              :order: '2'
              :contents:
                - :repo_id: 'test:9'
                  :use: 'baz'
    reverse:
      :type: 'reverse'
      :contents:
        - :label: 'Back'
          :order: '1'
          :contents:
            - :label: 'Bottom'
              :order: '1'
              :contents:
                - :repo_id: 'test:9'
                  :use: 'baz'
            - :label: 'Top'
              :order: '2'
              :contents:
                - :repo_id: 'test:8'
                  :use: 'bar'
        - :label: 'Front'
          :order: '2'
          :contents:
            - :repo_id: 'test:7'
              :use: 'foo'
  eos
  YAML.load(yaml)
end

def simple_structure_to_json
  simple_structure_dereferenced_hash.to_json
end

def nested_structure_to_json
  nested_structure_dereferenced_hash.to_json
end

def nested_structure_mptr_to_json
  nested_structure_mptr_dereferenced_hash.to_json
end

def multiple_struct_maps_structure_to_json
  multiple_struct_maps_structure_dereferenced_hash.to_json
end
