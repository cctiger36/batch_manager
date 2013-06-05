require 'log4r'

module BatchManager
  class Logger
    attr_accessor :logger
    attr_reader :log_file
    delegate :debug, :info, :warn, :error, :fatal, :add, :to => :logger

    def initialize(batch_name, is_wet)
      @logger = Log4r::Logger.new(batch_name)
      @logger.outputters << Log4r::Outputter.stdout
      if BatchManager.save_log?
        log_file_name = is_wet ? "#{batch_name}_wet" : batch_name
        @log_file = log_file_path(log_file_name)
        @logger.outputters << Log4r::FileOutputter.new(log_file_name, :filename => @log_file)
      end
      Rails.logger = self
    end

    def log_file_path(file_name)
      file_path = File.join(BatchManager.log_dir, file_name) + ".log"
      FileUtils.mkdir_p(File.dirname(file_path)) unless File.exist?(file_path)
      file_path
    end
  end
end
