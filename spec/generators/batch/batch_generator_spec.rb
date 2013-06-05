require 'spec_helper'
require 'generators/batch/batch_generator'

describe Rails::Generators::BatchGenerator do
  destination temp_dir

  before do
    prepare_destination
    Rails::Generators.options[:rails][:orm] = :active_record
  end

  describe 'the generated files' do
    before { run_generator %w(test subdir/test) }

    describe 'test.rb' do
      subject { file(File.join(BatchManager.batch_dir, 'test.rb')) }
      it { should exist }
      it { should contain("=Batch Manager=") }
      it "should use BatchManager.logger to write log" do
        should contain("BatchManager.logger")
      end
    end
  end

  describe 'the generated files in subdir' do
    before { run_generator %w(subdir/test) }
    
    describe "subdir/test.rb" do
      subject { file(File.join(BatchManager.batch_dir, 'subdir/test.rb')) }
      it { should exist }
      it { should contain("=Batch Manager=") }
    end
  end
end
