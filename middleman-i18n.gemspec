# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "middleman-i18n/version"

Gem::Specification.new do |s|
  s.name        = "middleman-i18n"
  s.version     = Middleman::I18n::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Thomas Reynolds"]
  s.email       = ["me@tdreyno.com"]
  s.homepage    = "https://github.com/tdreyno/middleman-i18n"
  s.summary     = %q{Basic i18n for Middleman}
  s.description = %q{Basic i18n for Middleman}

  s.rubyforge_project = "middleman-i18n"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency("middleman", ["~> 2.0.14"])
  s.add_development_dependency("cucumber", ["~> 1.0.2"])
  s.add_development_dependency("rake", ["~> 0.9.2"])
  s.add_development_dependency("rspec", ["~> 2.6.0"])
end
