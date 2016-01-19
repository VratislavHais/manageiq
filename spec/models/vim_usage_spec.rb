describe VimUsage do
  context "with a Vm" do
    let(:vm) { FactoryGirl.create(:vm_vmware) }

    context ".last_capture" do
      it "without data" do
        described_class.last_capture # .should be_nil
      end

      it "with data" do
        FactoryGirl.create(:metric_rollup_vm_hr, :resource => vm, :timestamp => 10.minutes.ago.utc)
        FactoryGirl.create(:metric_rollup_vm_hr, :resource => vm, :timestamp => 5.minutes.ago.utc)
        last = FactoryGirl.create(:metric_rollup_vm_hr, :resource => vm, :timestamp => Time.now.utc)
        expect(described_class.last_capture).to be_same_time_as last.timestamp
      end
    end

    context ".first_capture" do
      it "without data" do
        expect(described_class.first_capture).to be_nil
      end

      it "with data" do
        first = FactoryGirl.create(:metric_rollup_vm_hr, :resource => vm, :timestamp => 10.minutes.ago.utc)
        FactoryGirl.create(:metric_rollup_vm_hr, :resource => vm, :timestamp => 5.minutes.ago.utc)
        FactoryGirl.create(:metric_rollup_vm_hr, :resource => vm, :timestamp => Time.now.utc)
        expect(described_class.first_capture).to be_same_time_as first.timestamp
      end
    end

    context ".first_and_last_capture" do
      it "without data" do
        expect(described_class.first_and_last_capture).to eq([])
      end

      it "with one record" do
        first = FactoryGirl.create(:metric_rollup_vm_hr, :resource => vm, :timestamp => Time.now.utc)
        actual = described_class.first_and_last_capture
        expect(actual.length).to eq(2)
        expect(actual[0]).to be_same_time_as first.timestamp
        expect(actual[1]).to be_same_time_as first.timestamp
      end

      it "with multiple records" do
        first = FactoryGirl.create(:metric_rollup_vm_hr, :resource => vm, :timestamp => 10.minutes.ago.utc)
        FactoryGirl.create(:metric_rollup_vm_hr, :resource => vm, :timestamp => 5.minutes.ago.utc)
        last = FactoryGirl.create(:metric_rollup_vm_hr, :resource => vm, :timestamp => Time.now.utc)
        actual = described_class.first_and_last_capture
        expect(actual.length).to eq(2)
        expect(actual[0]).to be_same_time_as first.timestamp
        expect(actual[1]).to be_same_time_as last.timestamp
      end
    end
  end
end
