require 'rails/generators'
require 'rails/generators/named_base'

module Rails
  module Generators
    class BatchGenerator < NamedBase

      desc "Generates batch file"

      def self.orm
        Rails::Generators.options[:rails][:orm]
      end

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates', (orm.to_s unless orm.class.eql?(String)) )
      end

      def create_batch_file
        template 'batch.rb', File.join(BatchManager.batch_dir, class_path, "#{file_name}.rb")
      end
    end
  end
end
