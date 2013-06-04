require 'spec_helper'

describe BatchManager::Executor do
  it "should raise exception when batch file not exist" do
    expect { BatchManager::Executor.exec("not_exist_file") }.to raise_error("File not exist.")
  end

  describe "execute batch file" do
    before(:all) do
      @batch_name = "test_executor"
      @created_at = Time.now
      @batch_file_path = create_batch_file(@batch_name, created_at: @created_at)
      @before_batch_status = BatchManager::BatchStatus.new(@batch_file_path)
    end

    context "dry run" do
      before(:all) do
        BatchManager::Executor.exec(@batch_name)
        @log_file_path = File.join(BatchManager.log_dir, @batch_name) + ".log"
      end

      it "should place logfile in the configured log directory" do
        File.exist?(@log_file_path).should be_true
      end

      it "should include 'DRY RUN' in log header" do
        File.read(@log_file_path).include?("DRY RUN").should be_true
      end

      it "should write output to logfile" do
        File.read(@log_file_path).include?("This is test_executor").should be_true
      end

      after(:all) { FileUtils.rm(@log_file_path) }
    end

    context "wet run" do
      before(:all) do
        BatchManager::Executor.exec(@batch_name, :wet => true)
        @log_file_path = File.join(BatchManager.log_dir, @batch_name) + "_wet.log"
      end

      it "should place logfile in the configured log directory" do
        File.exist?(@log_file_path).should be_true
      end

      it "should include 'WET RUN' in log header" do
        File.read(@log_file_path).include?("WET RUN").should be_true
      end

      after(:all) { FileUtils.rm(@log_file_path) }
    end
  end
end
