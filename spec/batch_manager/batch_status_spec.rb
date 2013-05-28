require 'spec_helper'

describe BatchManager::BatchStatus do
  before(:all) do
    @batch_name = "test_batch_status"
    @temp_dir = File.expand_path("../../../tmp", __FILE__)
    FileUtils.mkdir_p @temp_dir
    @batch_file_path = File.join(@temp_dir, @batch_name) + ".rb"
    @created_at = Time.now.strftime "%Y-%m-%d %H:%M:%S"
    @times_limit = 3
    @auto_run = true
    content = <<-STR
      # =Batch Manager=
      # =created_at: #{@created_at}
      # =times_limit: #{@times_limit}
      # =auto_run: #{@auto_run}
    STR
    content.gsub!(/^( |\t)+/, '')
    File.open(@batch_file_path, "w") { |f| f << content }
    @batch_status = BatchManager::BatchStatus.new(@batch_file_path)
  end

  describe "batch status" do
    subject { @batch_status }
    it { subject.name.should == @batch_name }
    it { subject.path.should == @batch_file_path }
    it { subject.managed?.should be_true }
    it { subject.created_at.strftime("%Y-%m-%d %H:%M:%S").should == @created_at }
    it { subject.times_limit.should == @times_limit }
    it { subject.auto_run.should == @auto_run }
    it { subject.schema_batch.should be_nil }
    it { subject.can_run?.should be_true }
  end

  describe "#can_run?" do
    before do
      @schema_batch = BatchManager::SchemaBatch.create! do |s|
        s.name = @batch_name
        s.ran_times = 2
      end
    end

    it "should be true when ran_times < times_limit" do
      @batch_status.can_run?.should be_true
    end

    it "should be false when ran_times == times_limit" do
      @schema_batch.update_attributes(:ran_times => 3)
      @batch_status.can_run?.should be_false
    end

    it "should be false when ran_times > times_limit" do
      @schema_batch.update_attributes(:ran_times => 4)
      @batch_status.can_run?.should be_false
    end

    after do
      @schema_batch.delete
    end
  end

  after(:all) { FileUtils.rm_rf(@temp_dir) }
end
