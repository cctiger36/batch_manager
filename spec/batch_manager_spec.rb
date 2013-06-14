require 'spec_helper'

describe BatchManager do

  it ".batch_dir should equal with configured batch_dir" do
    BatchManager.batch_dir.should == temp_dir
  end

  describe "::logger" do
    it "should be a Logger as default" do
      BatchManager.logger.should be_an_instance_of(::Logger)
    end
  end

end
