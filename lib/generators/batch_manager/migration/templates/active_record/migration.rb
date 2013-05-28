class BatchManagerMigration < ActiveRecord::Migration
  def self.up
    create_table :schema_batches do |t|
      t.string :name
      t.integer :ran_times, :default => 0
      t.datetime :last_ran_at
    end
    add_index :schema_batches, :name
  end

  def self.down
    drop_table :schema_batches
  end
end
