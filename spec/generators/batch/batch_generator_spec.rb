require 'spec_helper'
require 'generators/batch/batch_generator'

describe Rails::Generators::BatchGenerator do
  destination File.expand_path("../../../../tmp", __FILE__)

  before do
    prepare_destination
    Rails::Generators.options[:rails][:orm] = :active_record
  end

  describe 'the generated files' do
    before { run_generator %w(test) }

    describe 'script/batch/test.rb' do
      subject { file('script/batch/test.rb') }
      it { should exist }
      it { should contain(/=Batch Manager=/) }
    end
  end
end
