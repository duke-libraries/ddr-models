RSpec.shared_examples "a role set" do

  let(:role1) { FactoryGirl.build(:role, :editor, :person, :resource) }
  let(:role2) { FactoryGirl.build(:role, :curator, :group, :policy) }
  let(:role3) { FactoryGirl.build(:role, :viewer, :public) }  

  describe "#grant" do
    describe "by attributes" do
      it "should be able to grant a role" do
        subject.grant role1.to_h
        expect(subject.to_a).to eq([role1])
      end
      it "should not grant duplicate roles" do
        subject.grant role1.to_h
        subject.grant role1.to_h
        expect(subject.to_a).to eq([role1])
      end
      it "should be able to grant multiple roles" do
        subject.grant role1.to_h, role2.to_h
        expect(subject.to_a).to eq([role1, role2])
      end
    end
    describe "by resource" do
      it "should be able to grant a role by role instance" do
        subject.grant role1
        expect(subject.to_a).to eq([role1])
      end
      it "should not grant duplicate roles" do
        subject.grant role1
        subject.grant role1
        expect(subject.to_a).to eq([role1])
      end
      it "should be able to grant multiple roles" do
        subject.grant role1, role2
        expect(subject.to_a).to eq([role1, role2])
      end
    end
  end

  describe "#revoke" do
    before { subject.grant role1, role2 }
    it "should be able to revoke a role by type, agent name and (optionally) scope" do
      subject.revoke role1.to_h
      expect(subject.to_a).to eq([role2])
    end
    it "should be able to revoke a role by role instance" do
      subject.revoke role1
      expect(subject.to_a).to eq([role2])
    end
    it "should be able to revoke multiple roles" do
      subject.revoke role1, role2
      expect(subject.empty?).to be true
    end
  end
  
  describe "#revoke_all" do
    before { subject.grant role1, role2 }
    it "should revoke all roles" do
      subject.revoke_all
      expect(subject.empty?).to be true
    end
  end

  describe "#replace" do
    before { subject.grant role1, role2 }
    it "should replace the current role(s) with the new role(s)" do
      expect { subject.replace(role3) }.to change(subject, :to_a).from([role1, role2]).to([role3])
    end
  end

  describe "#granted?" do
    before { subject.grant role1 }
    it "should return true if an equivalent role has been granted" do
      expect(subject.granted?(role1.dup)).to be true
    end
    it "should return false if no equivalent role has been granted" do
      expect(subject.granted?(role2)).to be false
    end
    it "should return true if a role matching the arguments has been granted" do
      expect(subject.granted?(role1.to_h)).to be true
      expect(subject.granted?(role2.to_h)).to be false
    end
  end
    
  describe "serialization" do
    let(:role1) { {type: "Editor", agent: "bob@example.com", scope: "resource"} }
    let(:role2) { {type: "Curator", agent: "sue@example.com", scope: "policy"} }
    before { subject.grant role1, role2 }
    its(:serialize) { should eq([{"role_type"=>["Editor"], "agent"=>["bob@example.com"], "scope"=>["resource"]}, {"role_type"=>["Curator"], "agent"=>["sue@example.com"], "scope"=>["policy"]}]) }
    its(:to_json) { should eq("[{\"role_type\":[\"Editor\"],\"agent\":[\"bob@example.com\"],\"scope\":[\"resource\"]},{\"role_type\":[\"Curator\"],\"agent\":[\"sue@example.com\"],\"scope\":[\"policy\"]}]") }
  end

  describe "conversion to array" do
    let(:roles) { FactoryGirl.build_list(:role, 3, :contributor, :person, :resource) }
    before { subject.grant *roles }
    its(:to_a) { should be_a(Array) }
    it { should contain_exactly(*roles) }
  end
    
end
