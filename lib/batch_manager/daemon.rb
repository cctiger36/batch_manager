require "daemon_spawn"

module BatchManager
  class Daemon
    include BatchManager::Utils

    class << self
      def spawn(command, batch_file, options = {})
        daemon_options = {
          working_dir: Rails.root.to_s,
          pid_file: pid_file_path(batch_name(batch_file), options[:wet]),
          log_file: BatchManager::Logger.log_file_path(batch_name(batch_file), options[:wet]),
          sync_log: true
        }
        FileUtils.mkdir_p(File.dirname(daemon_options[:pid_file]), :mode => 0775)
        Spawn.spawn!(daemon_options, [command, batch_file, options])
      end

      def pid_file_path(batch_name, is_wet = false)
        pid_file_name = is_wet ? "#{batch_name}_wet" : batch_name
        File.join(BatchManager.log_dir, pid_file_name) + ".pid"
      end
    end

    class Spawn < ::DaemonSpawn::Base
      def start(args)
        BatchManager::Executor.exec(args[0], args[1])
      end

      def stop
      end
    end
  end
end
