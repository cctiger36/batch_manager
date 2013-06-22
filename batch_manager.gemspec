$:.push File.expand_path("../lib", __FILE__)

require "batch_manager/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "batch_manager"
  s.version     = BatchManager::VERSION
  s.authors     = ["Weihu Chen"]
  s.email       = ["cctiger36@gmail.com"]
  s.homepage    = "https://github.com/cctiger36/batch_manager"
  s.summary     = "A rails plugin to manage batch scripts."
  s.description = "A rails plugin to manage batch scripts. Provide web interface to create, edit and execute batch scripts simply. Automatically save the log to file."
  s.license     = 'MIT'

  s.files       = Dir["{app,config,bin,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.bindir      = 'bin'
  s.executables = ['bm_exec']
  s.require_path = 'lib'

  s.add_dependency "rails", ">=3.1.0"
  s.add_dependency "log4r"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "ammeter"
  s.add_development_dependency "resque"
end
