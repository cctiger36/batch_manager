module BatchManager
  class Executor
    include BatchManager::Utils

    class << self
      def exec(batch_file, options = {})
        batch_file_path = batch_full_path(batch_file)
        if File.exist?(batch_file_path)
          batch_status = BatchManager::BatchStatus.new(batch_file_path)
          @wet = options[:wet]
          if !@wet || options[:force] || batch_status.can_run?
            logger = BatchManager::Logger.new(batch_status.name, @wet)
            write_log_header(@wet)
            begin
              eval(File.read(batch_file_path))
              batch_status.update_schema if @wet
            rescue => e
              logger.error e
              logger.error "Failed."
            ensure
              puts "Log saved at: #{BatchManager.logger.log_file}" if logger.log_file
              logger.close
            end
          else
            raise "Cannot run this batch."
          end
        else
          raise "File not exist."
        end
      end

      def write_log_header(is_wet)
        BatchManager.logger.info "=============================="
        BatchManager.logger.info "= #{is_wet ? 'WET' : 'DRY'} RUN"
        BatchManager.logger.info "= Ran at: #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
        BatchManager.logger.info "=============================="
      end
    end
  end
end
