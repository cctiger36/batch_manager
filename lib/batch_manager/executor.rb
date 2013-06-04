module BatchManager
  class Executor
    include BatchManager::Utils

    class << self
      def exec(batch_file, options = {})
        batch_file_path = batch_full_path(batch_file)
        if File.exist?(batch_file_path)
          batch_status = BatchManager::BatchStatus.new(batch_file_path)
          if options[:force] || batch_status.can_run?
            @wet = options[:wet]
            origin_stdout = STDOUT.clone
            logfile_name = @wet ? "#{batch_status.name}_wet" : batch_status.name
            STDOUT.reopen(logfile(logfile_name))
            puts log_header(@wet)
            eval(File.read(batch_file_path))
            STDOUT.reopen(origin_stdout)
            batch_status.update_schema
          else
            raise "Cannot run this batch."
          end
        else
          raise "File not exist."
        end
      end

      def logfile(file_name)
        file_path = File.join(BatchManager.log_dir, file_name) + ".log"
        FileUtils.mkdir_p(File.dirname(file_path)) unless File.exist?(file_path)
        File.new(file_path, File::WRONLY | File::APPEND | File::CREAT)
      end

      def log_header(is_wet)
        header = "=============================="
        header << "= #{is_wet ? 'WET' : 'DRY'} RUN"
        header << "= Ran at: #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
        header << "=============================="
      end
    end
  end
end
