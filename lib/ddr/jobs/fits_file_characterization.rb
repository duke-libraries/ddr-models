require 'open3'

module Ddr::Jobs
  class FitsFileCharacterization
    extend Job

    @queue = :file_characterization

    EVENT_SUMMARY = 'FITS characterization of content file'.freeze

    def self.perform(pid)
      obj = ActiveFedora::Base.find(pid)
      tmp_filename = Ddr::Utils::sanitize_filename(obj.original_filename) || obj.content.default_file_name
      Dir.mktmpdir(nil, Ddr::Models.tempdir) do |dir|
        infile = create_temp_infile(dir, tmp_filename, obj.content.content)
        fits_output, err, status = Open3.capture3(fits_command, '-i', infile)
        if status.success? && fits_output.present?
          obj.reload
          obj.fits.content = fits_output
          obj.save!
        end
        notify_event(pid, err, status)
      end
    end

    def self.fits_command
      File.join(Ddr::Models.fits_home, 'fits.sh')
    end

    def self.fits_version
      `#{fits_command} -v`.strip
    end

    private

    def self.create_temp_infile(dir, tmp_filename, content)
      temp_infile = File.join(dir, tmp_filename)
      File.open(temp_infile, 'wb') do |f|
        f.write content
      end
      temp_infile
    end

    def self.notify_event(pid, err, status)
      details = status.success? ? nil : err
      event_args = { pid: pid, summary: EVENT_SUMMARY, software:  "fits #{fits_version}", detail: details }
      event_args[:outcome] = status.success? ? Ddr::Events::Event::SUCCESS : Ddr::Events::Event::FAILURE
      Ddr::Notifications.notify_event(:update, event_args)
    end

  end
end
