namespace :batch do
  desc "List all batches"
  task :list do
    puts BatchManager::Monitor.batches
  end

  task :details => :environment do
    title = "%-12s" % "Managed?"
    title << "%-50s" % "Name"
    title << "%10s" % "Ran/Limit"
    title << "%25s" % "Last run at"
    title << "%25s" % "Created at"
    puts title
    BatchManager::Monitor.details.each do |status|
      schema_batch = status.schema_batch
      str = "%-12s" % (status.managed?? "Yes" : "")
      str << "%-50s" % status.name.truncate(45)
      str << "%10s" % "#{schema_batch.try(:ran_times).to_i}/#{status.times_limit || 0}"
      if last_ran_at = schema_batch.try(:last_ran_at)
        str << "%25s" % last_ran_at.strftime('%Y-%m-%d %H:%M:%S')
      else
        str << "%25s" % ""
      end
      str << "%25s" % status.created_at.strftime('%Y-%m-%d %H:%M:%S')
      puts str
    end
  end
end
