module Ddr::Index
  module LegacyLicenseFields

    DEFAULT_LICENSE_DESCRIPTION = Field.new :default_license_description, type: :string
    DEFAULT_LICENSE_TITLE       = Field.new :default_license_title, type: :string
    DEFAULT_LICENSE_URL         = Field.new :default_license_url, type: :string
    LICENSE_DESCRIPTION         = Field.new :license_description, type: :string
    LICENSE_TITLE               = Field.new :license_title, type: :string
    LICENSE_URL                 = Field.new :license_url, type: :string

  end
end
