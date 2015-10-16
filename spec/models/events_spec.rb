require 'spec_helper'
require 'support/shared_examples_for_events'

module Ddr
  module Events
    RSpec.describe Event, type: :model, events: true do
      it_behaves_like "an event"
    end

    RSpec.describe UpdateEvent, type: :model, events: true do
      it_behaves_like "an event"
      it "should have a display type" do
        expect(subject.display_type).to eq "Update"
      end
    end

    RSpec.describe CreationEvent, type: :model, events: true do
      it_behaves_like "an event"
      it_behaves_like "a preservation-related event"
      it "should have a display type" do
        expect(subject.display_type).to eq "Creation"
      end
    end

    RSpec.describe FixityCheckEvent, type: :model, events: true do
      it_behaves_like "an event"
      it_behaves_like "a preservation-related event"
      it_behaves_like "an event that reindexes its object after save"
      it "should have a display type" do
        expect(subject.display_type).to eq "Fixity Check"
      end
      describe "defaults" do
        it "should set software to the Fedora repository version" do
          pending "Fedora 4 API for getting repository version"
          expect(subject.software).to match /^Fedora Repository \d\.\d\.\d$/
        end
      end
    end

    RSpec.describe VirusCheckEvent, type: :model, events: true do
      it_behaves_like "an event"
      it_behaves_like "a preservation-related event"
      it_behaves_like "an event that reindexes its object after save"
      it "should have a display type" do
        expect(subject.display_type).to eq "Virus Check"
      end
    end

    RSpec.describe IngestionEvent, type: :model, events: true do
      it_behaves_like "an event"
      it_behaves_like "a preservation-related event"
      it "should have a display type" do
        expect(subject.display_type).to eq "Ingestion"
      end
    end

    RSpec.describe ValidationEvent, type: :model, events: true do
      it_behaves_like "an event"
      it_behaves_like "a preservation-related event"
      it "should have a display type" do
        expect(subject.display_type).to eq "Validation"
      end
    end

    RSpec.describe DeletionEvent, type: :model, events: true do
      it_behaves_like "an event"
      it_behaves_like "a preservation-related event"
      it "should have a display type" do
        expect(subject.display_type).to eq "Deletion"
      end
    end
  end
end
