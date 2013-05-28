require 'spec_helper'

describe BatchManager::Utils do

  class IncludeUtilsClass
    include BatchManager::Utils
  end

  describe "the instance of IncludeUtilsClass" do
    subject { IncludeUtilsClass.new }

    it { should respond_to :batch_path }
    it { subject.batch_path("test_batch.rb").should == "test_batch.rb" }
    it { subject.batch_path("subdir/test_batch.rb").should == "subdir/test_batch.rb" }
    it { subject.batch_path(File.join(BatchManager.batch_dir, "test_batch.rb")).should == "test_batch.rb" }

    it { should respond_to :batch_full_path }
    it { subject.batch_full_path("test_batch").should == File.join(BatchManager.batch_dir, "test_batch.rb") }
    it { subject.batch_full_path(File.join(BatchManager.batch_dir, "test_batch.rb")).should == File.join(BatchManager.batch_dir, "test_batch.rb") }
  end

  describe "IncludeUtilsClass" do
    subject { IncludeUtilsClass }
    it { should respond_to :batch_path }
    it { should respond_to :batch_full_path }
  end
end
