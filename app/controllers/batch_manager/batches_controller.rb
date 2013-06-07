module BatchManager
  class BatchesController < ApplicationController
    def index
      @details = BatchManager::Monitor.details
    end

    def exec
      @batch_name = params[:batch_name]
      @wet = params[:wet]
      if resque_supported?
        Resque.enqueue(BatchManager::ExecBatchWorker, @batch_name, :wet => @wet)
        @offset = log_file.size
      else
        BatchManager::Executor.exec(@batch_name, :wet => @wet)
        redirect_to(batches_url)
      end
    end

    def async_read_log
      file = log_file
      file.seek(params[:offset].to_i) if params[:offset].present?
      render :json => {:content => file.read, :offset => file.size}
    end

    def log
      log_file = BatchManager::Logger.log_file_path(params[:batch_name], params[:wet])
      render :file => log_file, :content_type => Mime::TEXT, :layout => false
    end

    private

    def resque_supported?
      begin
        require 'resque'
        defined?(Resque)
      rescue
        false
      end
    end

    def log_file
      File.open(BatchManager::Logger.log_file_path(params[:batch_name], params[:wet]), 'r')
    end
  end
end
