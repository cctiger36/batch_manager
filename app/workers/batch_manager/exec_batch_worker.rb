module BatchManager
  class ExecBatchWorker
    @queue = "batch_manager"

    def self.perform(batch_name, options = {})
      BatchManager::Executor.exec(batch_name, :wet => options[:wet])
    end

  end
end
