module BatchManager
  module Utils
    def self.included(base)
      base.send :include, OverallMethods
      base.extend OverallMethods
    end

    module OverallMethods
      def batch_path(filename_or_path)
        if filename_or_path.start_with?(::BatchManager.batch_dir)
          path = filename_or_path.sub("#{::BatchManager.batch_dir}/", "")
        else
          path = filename_or_path
        end
        path.end_with?(".rb") ? path : path + ".rb"
      end

      def batch_full_path(filename_or_path)
        if filename_or_path.start_with?(::BatchManager.batch_dir)
          path = filename_or_path
        else
          path = File.join(::BatchManager.batch_dir, filename_or_path)
        end
        path.end_with?(".rb") ? path : path + ".rb"
      end
    end
  end
end
