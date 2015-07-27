module Ddr::Datastreams
  class FitsDatastream < ActiveFedora::OmDatastream

    FITS_XMLNS = "http://hul.harvard.edu/ois/xml/ns/fits/fits_output".freeze
    FITS_SCHEMA = "http://hul.harvard.edu/ois/xml/xsd/fits/fits_output.xsd".freeze

    set_terminology do |t|
      t.root(path: "fits",
             xmlns: FITS_XMLNS,
             schema: FITS_SCHEMA)
      t.identification {
        t.identity {
          t.mimetype(path: {attribute: "mimetype"})
          t.format_label(path: {attribute: "format"})
          t.version
          t.pronom_identifier(path: "externalIdentifier", attributes: {type: "puid"})
        }
      }
      t.fileinfo {
        t.size
        t.creatingApplicationName
        t.created
        t.lastmodified
      }
      t.filestatus {
        t.valid
        t.well_formed(path: "well-formed")
      }
      t.metadata {
        t.image {
          t.imageWidth
          t.imageHeight
          t.colorSpace
        }
        t.document {
          # TODO - configure to get from Tika?
          # t.encoding
        }
      }
    end

    def self.xml_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.fits("xmlns"=>FITS_XMLNS,
                 "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
                 "xsi:schemaLocation"=>"http://hul.harvard.edu/ois/xml/ns/fits/fits_output http://hul.harvard.edu/ois/xml/xsd/fits/fits_output.xsd")
      end
      builder.doc
    end

  end
end
