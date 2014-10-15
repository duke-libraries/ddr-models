Ddr::Models.configure do |config|

  config.external_file_store = ENV['EXTERNAL_FILE_STORE']
  config.external_file_subpath_pattern = Rails.env.test? ? "--" : ENV['EXTERNAL_FILE_SUBPATH_PATTERN']
  config.noid_template = "2.reeddeeddk"
  config.minter_statefile = Rails.env.test? ? "/tmp/minter-state" : ENV['MINTER_STATEFILE']

end