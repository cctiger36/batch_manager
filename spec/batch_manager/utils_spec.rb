require 'spec_helper'

describe BatchManager::Utils do

  class IncludeUtilsClass
    include BatchManager::Utils
  end

  describe "the instance of IncludeUtilsClass" do
    subject { IncludeUtilsClass.new }
    it { should respond_to :batch_path }
    it { subject.batch_path("test_batch").should == "script/batch/test_batch.rb" }
    it { subject.batch_path("script/batch/test_batch.rb").should == "script/batch/test_batch.rb" }
  end
end
