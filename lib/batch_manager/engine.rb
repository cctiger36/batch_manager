module BatchManager
  class Engine < ::Rails::Engine
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__), '../tasks/*.rake')].each { |f| load f }
    end

    config.batch_manager = ActiveSupport::OrderedOptions.new
    config.batch_manager.batch_dir = "script/batch"
    config.batch_manager.save_log = true
    config.batch_manager.log_dir = "log/batch"
  end
end
