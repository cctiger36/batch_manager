# -*- coding: utf-8 -*-
# =Batch Manager=
# =created_at:  <%= Time.now.strftime "%Y-%m-%d %H:%M:%S" %>
# =times_limit: 1

wet_run = (ARGV[0] == "wet" || @wet)

ActiveRecord::Base.connection.with_standby do

  ActiveRecord::Base.transaction do

    if wet_run
      BatchManager.logger.info "Wet run completed!"
    else
      BatchManager.logger.warn "Rolling back."
      raise ActiveRecord::Rollback
    end
  end

end
