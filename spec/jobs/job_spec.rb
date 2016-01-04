module Ddr::Jobs
  RSpec.describe Job do

    before(:all) do
      class TestJob
        extend Job

        @queue = :test

        def perform(object_id)
          puts object_id
        end
      end
    end

    after(:all) do
      Ddr::Jobs.send(:remove_const, :TestJob)
    end

    let(:queued) do
      [{"class"=>"Ddr::Jobs::TestJob", "args"=>["test-1"]},
       {"class"=>"Ddr::Jobs::OtherJob", "args"=>["test-2"]},
       {"class"=>"Ddr::Jobs::TestJob", "args"=>["test-3"]},
      ]
    end

    before(:each) do
      allow(Resque).to receive(:size).with(:test) { 3 }
      allow(Resque).to receive(:peek).with(:test, 0, 3) { queued }
    end

    describe ".queued_object_ids" do
      it "returns the list of object_ids for queued jobs of this type" do
        expect(TestJob.queued_object_ids)
          .to contain_exactly("test-1", "test-3")
      end
    end

  end
end
