# BatchManager
===
[![Build Status](https://travis-ci.org/cctiger36/batch_manager.png?branch=master)](https://travis-ci.org/cctiger36/batch_manager) [![Gem Version](https://badge.fury.io/rb/batch_manager.png)](http://badge.fury.io/rb/batch_manager) [![Coverage Status](https://coveralls.io/repos/cctiger36/batch_manager/badge.png?branch=master)](https://coveralls.io/r/cctiger36/batch_manager?branch=master) [![Code Climate](https://codeclimate.com/github/cctiger36/batch_manager.png)](https://codeclimate.com/github/cctiger36/batch_manager)

A rails plugin to manage batch scripts similar to migrations.

## Installation
---

Add to your Gemfile

    gem 'batch_manager'

and bundle

    bundle

initialize

    bundle exec rails generate batch_manager:migration
    bundle exec rake db:migrate

This will create a table 'schema_batches' like 'schema_migrations' to save the status of batches in database.

## Configuration
---

    config.batch_manager.batch_dir = "script/batch"
    config.batch_manager.save_log = true
    config.batch_manager.log_dir = "log/batch"

You can change the default configuration in config/application.rb

## Batch Generator
---

    bundle exec rails g batch test

This will generate the file 'test.rb' in the configured batch_dir with default template.

You can find the template in lib/generators/batch/templates, and modify it for yourself.

## Batch Header
---

The generated batch files will have the header like:

    # =Batch Manager=
    # =created_at:  2013-05-24 13:10:25
    # =times_limit: 1
    # =group_name:  GroupName

Add the "=Batch Manager=" to tell BatchManager to manage this batch file.

You can also add these headers to the existing batch files.

## Execute Batch
---

    bundle exec bm_exec [options] BATCH_FILE

Please use this command instead of 'rails runner' to run batch scripts.

    option:
      -f, --force
      -w, --wet

## Logger
---

Please use BatchManager.logger in batch scripts to output logs, and then BatchManager will automatically also output logs to the file in the configured log directory.

    BatchManager.logger.debug
    BatchManager.logger.info
    BatchManager.logger.warn
    BatchManager.logger.error
    BatchManager.logger.fatal

When batches executed without BatchManager, it will write log to $stdout as default.

## Web interface
---

Mount the web interface in the routes file.

    mount BatchManager::Engine, :at => "batch_manager"

You can also use web interface to execute batches.

If [resque](https://github.com/resque/resque) installed in you application, the batch script can be executed asynchronous. And the log can be checked on real time in the brower.

## Rake Tasks
---

show all batches

    bundle exec rake batch:list

show the details of batches

    bundle exec rake batch:details
