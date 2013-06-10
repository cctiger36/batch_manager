module BatchManager
  class ApplicationController < ActionController::Base
    def resque_supported?
      begin
        require 'resque'
        if defined?(Resque)
          queue_names = []
          Resque.workers.map do |worker|
            queue_names += worker.id.split(':')[-1].split(',')
          end
          return true if queue_names.include?(BatchManager::ExecBatchWorker.queue_name) || queue_names.include?("*")
        end
        false
      rescue
        false
      end
    end
  end
end
