require 'spec_helper'

describe BatchManager::Daemon do
  before(:all) do
    @batch_name = "test_daemon"
    @created_at = Time.now
    @batch_file_path = create_batch_file(@batch_name, created_at: @created_at, code: "sleep 1")
  end

  describe "execute batch in daemon mode" do
    before(:all) do
      BatchManager::Daemon.spawn("start", @batch_name)
      @log_file_path = BatchManager::Logger.log_file_path(@batch_name)
      sleep 0.2
    end

    it "should create pid file in the configured log directory" do
      pid_file_path = BatchManager::Daemon.pid_file_path(@batch_name)
      pid_file_path.start_with?(Rails.application.config.batch_manager.log_dir).should be_true
      File.exist?(pid_file_path).should be_true
    end

    it "should place log file in the configured log directory" do
      @log_file_path.start_with?(Rails.application.config.batch_manager.log_dir).should be_true
      File.exist?(@log_file_path).should be_true
    end

    it "should write output to logfile" do
      File.read(@log_file_path).include?("This is test_daemon").should be_true
    end
  end
end
