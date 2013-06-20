require 'log4r'

module BatchManager
  class Logger
    attr_accessor :logger
    attr_reader :log_file
    delegate :debug, :info, :warn, :error, :fatal, :add, :to => :logger

    class << self
      def log_file_path(batch_name, is_wet = false)
        log_file_name = is_wet ? "#{batch_name}_wet" : batch_name
        File.join(BatchManager.log_dir, log_file_name) + ".log"
      end
    end

    def initialize(batch_name, is_wet)
      @logger = Log4r::Logger.new(batch_name)
      @logger.outputters << Log4r::Outputter.stdout
      if BatchManager.save_log?
        @log_file = prepare_log_file(batch_name, is_wet)
        @logger.outputters << Log4r::FileOutputter.new(File.basename(@log_file, ".log"), :filename => @log_file)
      end
      BatchManager.logger = self
    end

    def prepare_log_file(batch_name, is_wet)
      file_path = self.class.log_file_path(batch_name, is_wet)
      unless File.exist?(file_path)
        FileUtils.mkdir_p(File.dirname(file_path), :mode => 0775)
        FileUtils.touch(file_path)
        FileUtils.chmod(0664, file_path)
      end
      file_path
    end

    def close
      BatchManager.logger = nil
    end
  end
end
