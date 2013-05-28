namespace :batch do
  desc "List all batches"
  task :list do
    Dir[BatchManager.batch_dir].each do |f|
      puts f
    end
  end
end
