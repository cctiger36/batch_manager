module BatchManager
  module Utils
    def self.included(base)
      base.send :include, OverallMethods
      base.extend OverallMethods
    end

    module OverallMethods
      def batch_path(file)
        if file.start_with?(::BatchManager.batch_dir)
          file
        else
          File.join(::BatchManager.batch_dir, file) + ".rb"
        end
      end
    end
  end
end
