module BatchManager
  class Monitor
    include BatchManager::Utils

    class << self
      def batches
        arr = []
        Dir.glob(File.join(BatchManager.batch_dir, "**", "*.rb")).sort.each do |f|
          arr << batch_name(f)
        end
        arr
      end

      def details
        status_array = []
        Dir.glob(File.join(BatchManager.batch_dir, "**", "*.rb")).sort.each do |f|
          status_array << self.status(f)
        end
        status_array
      end

      def status(file_name)
        BatchManager::BatchStatus.new(file_name)
      end
    end
  end
end
