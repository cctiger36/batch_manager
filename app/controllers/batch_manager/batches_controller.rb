module BatchManager
  class BatchesController < ApplicationController
    def index
      @details = BatchManager::Monitor.details
    end

    def exec
      BatchManager::Executor.exec(params[:batch_name], :wet => params[:wet])
      redirect_to(batches_url)
    end

    def log
      log_file = BatchManager::Logger.log_file_path(params[:batch_name], params[:wet])
      render :file => log_file, :content_type => Mime::TEXT, :layout => false
    end
  end
end
