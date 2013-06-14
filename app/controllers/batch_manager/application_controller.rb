module BatchManager
  class ApplicationController < ActionController::Base
    def resque_supported?
      begin
        require 'resque'
        defined?(Resque) && resque_worker_started?
      rescue
        false
      end
    end

    def resque_worker_started?
      queue_names = []
      Resque.workers.map do |worker|
        queue_names += worker.id.split(':')[-1].split(',')
      end
      queue_names.include?(BatchManager::ExecBatchWorker.queue_name) || queue_names.include?("*")
    end
  end
end
