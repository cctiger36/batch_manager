require 'spec_helper'

describe BatchManager do

  it ".batch_dir should equal with configured batch_dir" do
    BatchManager.batch_dir.should == "script/batch"
  end

end
