module BatchManager
  class Executor
    include BatchManager::Utils

    class << self
      def exec(batch_file, options = {})
        @batch_file_path = batch_full_path(batch_file)
        if File.exist?(@batch_file_path)
          @batch_status = BatchManager::BatchStatus.new(@batch_file_path)
          @wet = options[:wet]
          if options[:force] || !@wet || @batch_status.can_run?
            record_run_duration { exec_batch_script }
          else
            raise "Cannot run this batch."
          end
        else
          raise "File not exist."
        end
      end

      protected

      def record_run_duration
        @logger = BatchManager::Logger.new(@batch_status.name, @wet)
        start_at = Time.now
        yield
        end_at = Time.now
        @logger.info "End at: #{end_at.strftime("%Y-%m-%d %H:%M:%S")} (#{(end_at - start_at).to_i}s)"
        @logger.close
      end

      def exec_batch_script
        write_log_header
        eval(File.read(@batch_file_path))
        @logger.info "Succeeded."
        @batch_status.update_schema if @wet
      rescue => e
        @logger.error e
        @logger.info "Failed."
      ensure
        puts "Log saved at: #{@logger.log_file}" if @logger.log_file
      end

      def write_log_header
        @logger.info "=============================="
        @logger.info "= #{@wet ? 'WET' : 'DRY'} RUN"
        @logger.info "= Ran at: #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
        @logger.info "=============================="
      end
    end
  end
end
