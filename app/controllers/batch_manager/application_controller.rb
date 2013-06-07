module BatchManager
  class ApplicationController < ActionController::Base
    def resque_supported?
      begin
        require 'resque'
        defined?(Resque)
      rescue
        false
      end
    end
  end
end
