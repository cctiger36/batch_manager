$:.push File.expand_path("../lib", __FILE__)

require "batch_manager/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "batch_manager"
  s.version     = BatchManager::VERSION
  s.authors     = ["Weihu Chen"]
  s.email       = ["cctiger36@gmail.com"]
  s.homepage    = "https://github.com/cctiger36/batch_manager"
  s.summary     = "A rails plugin to manage batch scripts similar to migrations."
  s.description = "A rails plugin to manage batch scripts similar to migrations."

  s.files       = Dir["{bin,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.bindir      = 'bin'
  s.executables = ['bm_exec']
  s.require_path = 'lib'

  s.add_dependency "rails", ">=3.0.0"
  s.add_dependency "log4r"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "ammeter"
end
