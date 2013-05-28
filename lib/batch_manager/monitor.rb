module BatchManager
  class Monitor
    include BatchManager::Utils

    class << self
      def batches
        arr = []
        Dir.glob(File.join(BatchManager.batch_dir, "**", "*.rb")).each do |f|
          arr << batch_name(f)
        end
        arr
      end

      def details
        status_array = []
        Dir.glob(File.join(BatchManager.batch_dir, "**", "*.rb")).each do |f|
          status_array << BatchManager::BatchStatus.new(f)
        end
        status_array
      end

      def status(file_name)
        # TODO
      end
    end
  end
end
