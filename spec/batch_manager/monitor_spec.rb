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

  after(:all) do
    FileUtils.rm(Dir.glob(File.join(BatchManager.batch_dir, "batch_*.rb")))
  end
end
