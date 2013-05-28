require 'spec_helper'

describe BatchManager::BatchStatus do
  describe "get batch status from BatchManager header" do
    before(:all) do
      @batch_name = "test_batch_status"
      @created_at = Time.now
      @times_limit = 2
      @auto_run = true
      @group_name = "group1"
      @batch_file_path = create_batch_file(@batch_name, created_at: @created_at, times_limit: @times_limit, auto_run: @auto_run, group_name: @group_name)
      @batch_status = BatchManager::BatchStatus.new(@batch_file_path)
    end

    describe "batch status" do
      subject { @batch_status }
      it { subject.name.should == @batch_name }
      it { subject.managed?.should be_true }
      it { subject.created_at.strftime("%Y-%m-%d %H:%M:%S").should == @created_at.strftime("%Y-%m-%d %H:%M:%S") }
      it { subject.times_limit.should == @times_limit }
      it { subject.auto_run.should == @auto_run }
      it { subject.group_name.should == @group_name }
      it { subject.schema_batch.should be_nil }
      it { subject.can_run?.should be_true }
    end

    describe "#can_run?" do
      before(:each) do
        @schema_batch = BatchManager::SchemaBatch.create! do |s|
          s.name = @batch_name
        end
      end

      it "should be true when ran_times < times_limit" do
        @schema_batch.update_attributes(:ran_times => 1)
        @batch_status.can_run?.should be_true
      end

      it "should be false when ran_times == times_limit" do
        @schema_batch.update_attributes(:ran_times => 2)
        @batch_status.can_run?.should be_false
      end

      it "should be false when ran_times > times_limit" do
        @schema_batch.update_attributes(:ran_times => 3)
        @batch_status.can_run?.should be_false
      end

      after(:each) { @schema_batch.delete }
    end

    describe "#update_schema" do
      context "managed batch" do
        it "should create schema_batch at first time invoked" do
          expect{@batch_status.update_schema}.to change{BatchManager::SchemaBatch.where(name: @batch_status.name).count}.from(0).to(1)
        end

        it "should update schema_batch from second time invoked" do
          expect{@batch_status.update_schema}.to_not change{BatchManager::SchemaBatch.where(name: @batch_status.name).count}.by(1)
        end

        it "should increase run_times" do
          expect{@batch_status.update_schema}.to change{BatchManager::SchemaBatch.where(name: @batch_status.name).first.ran_times}.by(1)
        end

        after(:all) { BatchManager::SchemaBatch.delete_all }
      end

      context "not managed batch" do
        before(:all) { @batch_status.managed = false }
        it "should not create or update schema_batch" do
          @batch_status.update_schema
          BatchManager::SchemaBatch.where(name: @batch_status.name).should be_empty
        end
        after(:all) { @batch_status.managed = true }
      end
    end

    after(:all) { FileUtils.rm(@batch_file_path) }
  end

  describe "batch files in subdir" do
    before(:all) do
      @batch_name = "subdir/test_batch_status"
      @batch_file_path = create_batch_file(@batch_name)
      @batch_status = BatchManager::BatchStatus.new(@batch_file_path)
    end

    subject { @batch_status }
    it { subject.name.should == @batch_name }

    after(:all) { FileUtils.rm(@batch_file_path) }
  end
end
