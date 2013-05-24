module BatchManager
  class Executor
    include BatchManager::Utils

    def self.exec(batch_file, options)
      batch_file_path = batch_path(batch_file)
      if File.exist?(batch_file_path)
        batch_status = BatchManager::BatchStatus.new(batch_file_path)
        if options[:force] || batch_status.can_run?
          @wet = options[:wet]
          eval File.read(batch_file_path)
          batch_status.update_schema
        else
          raise "Cannot run this batch."
        end
      else
        raise "File not exist."
      end
    end
  end
end
