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
    config.active_support.escape_html_entities_in_json = true
    config.batch_manager.batch_dir = "script/batch"
    config.batch_manager.save_log = true
    config.batch_manager.log_dir = "log/batch"
  end
end
