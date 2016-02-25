RSpec.shared_examples "a fixity checkable object" do

  describe "fixity check" do
    before do
      subject.thumbnail.content = '1234567890'
      subject.save(validate: false)
    end
    specify {
      expect { subject.check_fixity }.to change(subject.fixity_checks, :count).from(0).to(1)
    }
    describe "results" do
      let(:results) { subject.check_fixity }
      specify {
        expect(results).to be_success
      }
      specify {
        expect(results[:thumbnail]).to be true
      }
      describe "failure" do
        before {
          allow(subject.thumbnail).to receive(:check_fixity) { false }
        }
        specify {
          expect(results).not_to be_success
        }
      end
    end
  end

end
