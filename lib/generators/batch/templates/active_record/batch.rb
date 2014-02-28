# -*- coding: utf-8 -*-
# =Batch Manager=
# =created_at:  <%= Time.now.strftime "%Y-%m-%d %H:%M:%S" %>
# =times_limit: 1

ActiveRecord::Base.transaction do

  # Code at here will rollback when dry run.

  # @wet will be true when -f option passed.
  if @wet
    BatchManager.logger.info "Wet run completed!"
  else
    BatchManager.logger.warn "Rolling back."
    raise ActiveRecord::Rollback
  end
end
