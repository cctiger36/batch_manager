ActiveRecord::Schema.define :version => 0 do
  create_table "schema_batches", :force => true do |t|
    t.string :name
    t.integer :ran_times, :default => 0
    t.datetime :last_ran_at
  end
  add_index :schema_batches, :name
end
