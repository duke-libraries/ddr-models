require 'spec_helper'

module Ddr::Models
  RSpec.describe FitsXmlFile do

    let(:fits_xml) do
      <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<fits xmlns="http://hul.harvard.edu/ois/xml/ns/fits/fits_output" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://hul.harvard.edu/ois/xml/ns/fits/fits_output http://hul.harvard.edu/ois/xml/xsd/fits/fits_output.xsd" version="0.8.5" timestamp="7/3/15 8:29 PM">
  <identification>
    <identity format="Portable Document Format" mimetype="application/pdf" toolname="FITS" toolversion="0.8.5">
      <tool toolname="Jhove" toolversion="1.5" />
      <tool toolname="file utility" toolversion="5.04" />
      <tool toolname="Exiftool" toolversion="9.13" />
      <tool toolname="Droid" toolversion="6.1.3" />
      <tool toolname="NLNZ Metadata Extractor" toolversion="3.4GA" />
      <tool toolname="ffident" toolversion="0.2" />
      <tool toolname="Tika" toolversion="1.3" />
      <version toolname="Jhove" toolversion="1.5">1.6</version>
      <externalIdentifier toolname="Droid" toolversion="6.1.3" type="puid">fmt/20</externalIdentifier>
    </identity>
  </identification>
  <fileinfo>
    <size toolname="Jhove" toolversion="1.5">3786205</size>
    <creatingApplicationName toolname="Exiftool" toolversion="9.13" status="CONFLICT">Adobe Acrobat Pro 11.0.3 Paper Capture Plug-in/PREMIS Editorial Committee</creatingApplicationName>
    <creatingApplicationName toolname="NLNZ Metadata Extractor" toolversion="3.4GA" status="CONFLICT">Adobe Acrobat Pro 11.0.3 Paper Capture Plug-in/Acrobat PDFMaker 11 for Word</creatingApplicationName>
    <lastmodified toolname="Exiftool" toolversion="9.13" status="CONFLICT">2015:06:25 21:45:24-04:00</lastmodified>
    <lastmodified toolname="Tika" toolversion="1.3" status="CONFLICT">2015-06-08T21:22:35Z</lastmodified>
    <created toolname="Exiftool" toolversion="9.13" status="SINGLE_RESULT">2015:06:05 15:16:23-04:00</created>
    <filepath toolname="OIS File Information" toolversion="0.2" status="SINGLE_RESULT">/Users/dc/Downloads/premis-3-0-final.pdf</filepath>
    <filename toolname="OIS File Information" toolversion="0.2" status="SINGLE_RESULT">premis-3-0-final.pdf</filename>
    <md5checksum toolname="OIS File Information" toolversion="0.2" status="SINGLE_RESULT">432ab76d650bfdc8f8d4a98cea9634bb</md5checksum>
    <fslastmodified toolname="OIS File Information" toolversion="0.2" status="SINGLE_RESULT">1435283124000</fslastmodified>
  </fileinfo>
  <filestatus>
    <well-formed toolname="Jhove" toolversion="1.5" status="SINGLE_RESULT">true</well-formed>
    <valid toolname="Jhove" toolversion="1.5" status="SINGLE_RESULT">false</valid>
    <message toolname="Jhove" toolversion="1.5" status="SINGLE_RESULT">Invalid page tree node offset=390028</message>
    <message toolname="Jhove" toolversion="1.5" status="SINGLE_RESULT">Outlines contain recursive references.</message>
  </filestatus>
  <metadata>
    <document>
      <title toolname="Jhove" toolversion="1.5" status="CONFLICT">CONTENTS</title>
      <title toolname="Exiftool" toolversion="9.13" status="CONFLICT">PREMIS Data Dictionary for Preservation Metadata, Version 3.0</title>
      <author toolname="Exiftool" toolversion="9.13">PREMIS Editorial Committee</author>
      <language toolname="Jhove" toolversion="1.5">en</language>
      <pageCount toolname="Exiftool" toolversion="9.13">282</pageCount>
      <isTagged toolname="Jhove" toolversion="1.5" status="CONFLICT">no</isTagged>
      <isTagged toolname="NLNZ Metadata Extractor" toolversion="3.4GA" status="CONFLICT">yes</isTagged>
      <hasOutline toolname="Jhove" toolversion="1.5">yes</hasOutline>
      <hasAnnotations toolname="Jhove" toolversion="1.5" status="SINGLE_RESULT">no</hasAnnotations>
      <isRightsManaged toolname="Exiftool" toolversion="9.13" status="SINGLE_RESULT">no</isRightsManaged>
      <isProtected toolname="Exiftool" toolversion="9.13">no</isProtected>
      <hasForms toolname="NLNZ Metadata Extractor" toolversion="3.4GA" status="SINGLE_RESULT">yes</hasForms>
      <subject toolname="Tika" toolversion="1.3" status="SINGLE_RESULT">PREMIS</subject>
    </document>
  </metadata>
  <statistics fitsExecutionTime="2977">
    <tool toolname="OIS Audio Information" toolversion="0.1" status="did not run" />
    <tool toolname="ADL Tool" toolversion="0.1" status="did not run" />
    <tool toolname="Jhove" toolversion="1.5" executionTime="1034" />
    <tool toolname="file utility" toolversion="5.04" executionTime="912" />
    <tool toolname="Exiftool" toolversion="9.13" executionTime="842" />
    <tool toolname="Droid" toolversion="6.1.3" executionTime="336" />
    <tool toolname="NLNZ Metadata Extractor" toolversion="3.4GA" executionTime="2192" />
    <tool toolname="OIS File Information" toolversion="0.2" executionTime="351" />
    <tool toolname="OIS XML Metadata" toolversion="0.2" status="did not run" />
    <tool toolname="ffident" toolversion="0.2" executionTime="410" />
    <tool toolname="Tika" toolversion="1.3" executionTime="2911" />
  </statistics>
</fits>
XML
    end

    before do
      subject.content = fits_xml
    end

    it "should exclude Exiftool from modified" do
      expect(subject.modified).to eq(["2015-06-08T21:22:35Z"])
    end

  end
end
