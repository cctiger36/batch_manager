$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'rails/all'
require 'rspec/rails'
require 'ammeter/init'
require 'batch_manager'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => File.expand_path(File.dirname(__FILE__) + '/batch_manager_test.sqlite3')
)

load(File.dirname(__FILE__) + '/schema.rb')

ActiveRecord::Base.connection.execute "DELETE FROM #{BatchManager::SchemaBatch.table_name}"

module BatchManager
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.batch_manager.batch_dir = "script/batch"
    config.batch_manager.save_log = true
    config.batch_manager.log_dir = "log/batch"
  end
end

def temp_dir
  @temp_dir ||= File.expand_path("../../tmp", __FILE__)
end

def create_batch_file
  
end

RSpec.configure do |config|
  config.before(:all) { FileUtils.mkdir_p(temp_dir) }
  config.after(:all) { FileUtils.rm_rf(temp_dir) }
end
