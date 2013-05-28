require 'spec_helper'

describe BatchManager::Monitor do
  before(:all) do
    @batches = []
    3.times do |index|
      @batches << "batch_#{index}"
      create_batch_file("batch_#{index}")
    end
  end

  describe "::batches" do
    it "should get names of batch files" do
      BatchManager::Monitor.batches.should == @batches
    end
  end

  describe "::status" do
    it "should return the BatchStatus object" do
      file = BatchManager::Monitor.batch_full_path(@batches[0])
      BatchManager::Monitor.status(file).should be_an_instance_of(BatchManager::BatchStatus)
    end
  end

  describe "::details" do
    it "should return all BatchStatus objects of the exsiting bathes" do
      BatchManager::Monitor.details.count.should == 3
    end
  end

  after(:all) do
    FileUtils.rm(Dir.glob(File.join(BatchManager.batch_dir, "batch_*.rb")))
  end
end
