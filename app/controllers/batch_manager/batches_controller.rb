module BatchManager
  class BatchesController < ApplicationController
    def index
      @details = BatchManager::Monitor.details
    end

    def exec
      BatchManager::Executor.exec(params[:batch_name], :wet => params[:wet])
      redirect_to(batch_manager_batches_url)
    end

    def log
      log_file = BatchManager::Logger.log_file_path(params[:batch_name], params[:wet])
      render :text => File.read(log_file).gsub("\n", "<br/>")
    end
  end
end
