$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'rails/all'
require 'rspec/rails'
require 'ammeter/init'
require 'batch_manager'

require 'coveralls'
Coveralls.wear!

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

load(File.dirname(__FILE__) + '/schema.rb')

ActiveRecord::Base.connection.execute "DELETE FROM #{BatchManager::SchemaBatch.table_name}"

def temp_dir
  @temp_dir ||= File.expand_path("../../tmp", __FILE__)
end

def create_batch_file(batch_name, options = {})
  content = "# =Batch Manager="
  content << "\n# =created_at: #{(options[:created_at] || Time.now).strftime("%Y-%m-%d %H:%M:%S")}"
  content << "\n# =times_limit: #{options[:times_limit]}" if options[:times_limit]
  content << "\n# =group_name: #{options[:group_name]}" if options[:group_name]
  content << "\nBatchManager.logger.info 'This is #{batch_name}'"
  content << "\n#{options[:code]}" if options[:code]
  FileUtils.mkdir_p(File.join(temp_dir, File.dirname(batch_name))) if batch_name.include?("/")
  file_path = File.join(temp_dir, batch_name) + ".rb"
  File.open(file_path, "w") { |f| f << content }
  file_path
end

module BatchManager
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.batch_manager.batch_dir = temp_dir
    config.batch_manager.save_log = true
    config.batch_manager.log_dir = File.join(temp_dir, "log")
  end
end

RSpec.configure do |config|
  config.before(:all) { FileUtils.mkdir_p(temp_dir) }
  config.after(:all) { FileUtils.rm_rf(temp_dir) }
end
