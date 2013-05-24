module BatchManager
  class BatchStatus
    attr_accessor :name, :created_at, :times_limit, :auto_run, :group_name, :path, :managed

    def initialize(path)
      @path = path
      @name = File.basename(path, ".rb")
      File.open path do |f|
        f.each_line do |line|
          parse_batch_content line
        end
      end
    end

    def schema_batch
      BatchManager::SchemaBatch.find_by_name(@name) if @name
    end

    def update_schema
      if managed?
        if schema_batch
          schema_batch.increment!(:ran_times)
        else
          BatchManager::SchemaBatch.create! do |s|
            s.name = @name
            s.ran_times = 1
            s.last_ran_at = Time.now
          end
        end
      end
    end

    def to_s
      # TODO
    end

    def managed?
      @managed
    end

    def can_run?
      @times_limit.to_i <= 0 || @times_limit > schema_batch.try(:ran_times).to_i
    end

    def parse_batch_content(line)
      if line.start_with?("#")
        @managed = true if line.include?(BatchManager.signal)
        if managed?
          if line.include?("=times_limit:")
            @times_limit = line.sub(/#\s*=times_limit:/, "").strip.to_i
          elsif line.include?("=created_at:")
            @created_at = Time.parse(line.sub(/#\s*=created_at:/, "").strip)
          elsif line.include?("=auto_run:")
            @auto_run = line.sub(/#\s*=auto_run:/, "").strip.downcase == "true"
          elsif line.include?("=group_name:")
            @group_name = line.sub(/#\s*=group_name:/, "").strip
          end
        end
      end
    end
  end
end
