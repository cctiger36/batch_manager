module BatchManager
  class Executor
    include BatchManager::Utils

    class << self
      def exec(batch_file, options = {})
        batch_file_path = batch_full_path(batch_file)
        if File.exist?(batch_file_path)
          batch_status = BatchManager::BatchStatus.new(batch_file_path)
          if options[:force] || !options[:wet] || batch_status.can_run?
            exec_batch_script(batch_file_path, batch_status, options[:wet])
          else
            raise "Cannot run this batch."
          end
        else
          raise "File not exist."
        end
      end

      protected

      def exec_batch_script(batch_file_path, batch_status, is_wet)
        logger = BatchManager::Logger.new(batch_status.name, is_wet)
        write_log_header(is_wet)
        start_at = Time.now
        begin
          @wet = is_wet
          eval(File.read(batch_file_path))
          end_at = Time.now
          logger.info "Completed at: #{end_at.strftime("%Y-%m-%d %H:%M:%S")} (#{(end_at - start_at).to_i}s)"
          batch_status.update_schema if is_wet
        rescue => e
          logger.error e
          end_at = Time.now
          logger.info "Failed at: #{end_at.strftime("%Y-%m-%d %H:%M:%S")} (#{(end_at - start_at).to_i}s)"
        ensure
          puts "Log saved at: #{BatchManager.logger.log_file}" if logger.log_file
          logger.close
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
