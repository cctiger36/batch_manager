require 'generators/batch/batch_generator'

module BatchManager
  class BatchesController < ApplicationController
    include BatchManager::Utils
    before_filter :retain_batch_params, :except => [:index, :new, :create]
    helper_method :escape_batch_name

    def index
      @details = BatchManager::Monitor.details
    end

    def new
      template = File.read(File.join(Rails::Generators::BatchGenerator.source_root, "batch.rb"))
      @content = ERB.new(template).result(binding)
    end

    def create
      batch_name = params[:batch_name]
      if batch_name.blank?
        flash[:error] = "Please input the batch name."
        redirect_to(new_batch_url) and return 
      end
      file_path = File.join(BatchManager.batch_dir, batch_name)
      file_path << ".rb" unless file_path.end_with?(".rb")
      FileUtils.mkdir_p(File.dirname(file_path)) if batch_name.include?("/")
      File.open(file_path, "w") { |f| f << params[:content] }
      redirect_to(batches_url, :notice => "#{batch_name} created.")
    end

    def edit
      @content = File.read(batch_full_path(@batch_name))
    end

    def update
      File.open(batch_full_path(@batch_name), "w") { |f| f << params[:content] }
      redirect_to(batches_url, :notice => "#{@batch_name} updated.")
    end

    def exec
      if resque_supported?
        Resque.enqueue(BatchManager::ExecBatchWorker, @batch_name, :wet => @wet)
        if local_resque_worker?
          redirect_to(log_batch_url(:batch_name => @batch_name, :wet => @wet, :refresh => true))
        else
          redirect_to(batches_url, :notice => "(#{@batch_name}) Task added to the remote resque worker.")
        end
      else
        BatchManager::Executor.exec(@batch_name, :wet => @wet)
        redirect_to(batches_url)
      end
    end

    def log
      @offset = log_file.size
      @content = log_file.read
    end

    def async_read_log
      log_file.seek(params[:offset].to_i) if params[:offset].present?
      render :json => {:content => log_file.read, :offset => log_file.size}
    end

    def remove_log
      FileUtils.rm(BatchManager::Logger.log_file_path(@batch_name, @wet))
      redirect_to(batches_url, :notice => "Log removed.")
    end

    def escape_batch_name(name)
      name.gsub("/", "|")
    end

    def unescape_batch_name(name)
      name.gsub("|", "/")
    end

    private

    def retain_batch_params
      @batch_name = unescape_batch_name(params[:id])
      @wet = params[:wet]
    end

    def log_file
      5.times do
        begin
          @log_file ||= File.open(BatchManager::Logger.log_file_path(@batch_name, @wet), 'r')
          return @log_file
        rescue
          sleep 2
          retry
        end
      end
    end
  end
end
