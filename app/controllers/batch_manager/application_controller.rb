require 'socket'

module BatchManager
  class ApplicationController < ActionController::Base
    helper_method :resque_supported?, :local_resque_worker?, :resque_worker_hostname

    def resque_supported?
      begin
        require 'resque'
        defined?(Resque) && resque_worker
      rescue
        false
      end
    end

    def local_resque_worker?
      Socket.gethostname == resque_worker_hostname
    end

    def resque_worker_hostname
      resque_worker.id.split(':')[0]
    end

    private

    def resque_worker
      @resque_worker ||= begin
        workers = Resque.workers.select do |worker|
          queue_names = worker.id.split(':')[-1].split(',')
          queue_names.include?(BatchManager::ExecBatchWorker.queue_name) || queue_names.include?("*")
        end
        workers.first
      end
    end
  end
end
