module BatchManager
  class SchemaBatch < ::ActiveRecord::Base
    self.table_name = "schema_batches"
  end
end
