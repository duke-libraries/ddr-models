FactoryGirl.define do

  factory :attachment do
    dc_title [ "Test Attachment" ]
    sequence(:dc_identifier) { |n| [ "att%05d" % n ] }
    after(:build) do |a|
      a.upload File.new(File.join(Ddr::Models::Engine.root.to_s, 'spec', 'fixtures', 'sample.docx'))
    end
  end

end
