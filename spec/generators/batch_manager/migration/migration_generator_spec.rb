require 'spec_helper'
require 'generators/batch_manager/migration/migration_generator'

describe BatchManager::MigrationGenerator do
  destination temp_dir

  context "when active_record" do
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

  context "when orm hasn't migration" do
    before do
      prepare_destination
      Rails::Generators.options[:rails][:orm] = :mongoid
    end

    describe 'the generated files' do
      before { run_generator }

      describe 'db/migrate/batch_manager_migration.rb' do
        subject { file('db/migrate/batch_manager_migration.rb') }
        it { should_not exist }
      end
    end
  end
end
