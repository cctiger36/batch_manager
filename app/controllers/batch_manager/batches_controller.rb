module BatchManager
  class BatchesController < ApplicationController
    before_filter :retain_batch_params, :except => [:index]

    def index
      @details = BatchManager::Monitor.details
    end

    def exec
      if resque_supported?
        Resque.enqueue(BatchManager::ExecBatchWorker, @batch_name, :wet => @wet)
        redirect_to(log_batches_url(:batch_name => @batch_name, :wet => @wet))
      else
        BatchManager::Executor.exec(@batch_name, :wet => @wet)
        redirect_to(batches_url)
      end
    end

    def async_read_log
      log_file.seek(params[:offset].to_i) if params[:offset].present?
      render :json => {:content => log_file.read, :offset => log_file.size}
    end

    def log
      @offset = log_file.size
      @content = log_file.read
    end

    private

    def retain_batch_params
      @batch_name = params[:batch_name]
      @wet = params[:wet]
    end

    def resque_supported?
      begin
        require 'resque'
        defined?(Resque)
      rescue
        false
      end
    end

    def log_file
      20.times do
        begin
          @log_file ||= File.open(BatchManager::Logger.log_file_path(@batch_name, @wet), 'r')
          return @log_file
        rescue
          sleep 3
          retry
        end
      end
    end
  end
end
