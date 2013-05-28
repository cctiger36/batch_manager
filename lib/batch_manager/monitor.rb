module BatchManager
  class Monitor
    include BatchManager::Utils

    class << self
      def batches
        arr = []
        Dir.glob(File.join(BatchManager.batch_dir, "**", "*.rb")).each do |f|
          arr << batch_path(f).sub(".rb", "")
        end
        arr
      end

      def list
        # TODO
      end

      def status(file_name)
        # TODO
      end
    end
  end
end
