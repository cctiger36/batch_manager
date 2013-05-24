require 'spec_helper'
require 'generators/batch_manager/migration/migration_generator'

describe BatchManager::MigrationGenerator do
  destination File.expand_path("../../../../../tmp", __FILE__)

  before do
    prepare_destination
    Rails::Generators.options[:rails][:orm] = :active_record
  end

  describe 'the generated files' do
    before { run_generator }

    describe 'db/migrate/batch_manager_migration.rb' do
      subject { file('db/migrate/batch_manager_migration.rb') }
      it { should be_a_migration }
    end
  end
end
