# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "vgtd/version"

Gem::Specification.new do |s|
  s.name        = "vgtd"
  s.version     = Vgtd::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andy Leak"]
  s.email       = ["andy@r210.com"]
  s.homepage    = "http://github.com/andyl/vgtd"
  s.summary     = %q{VimGTD}
  s.description = %q{Helper classes for VimGTD}

  s.add_dependency 'rake'          , '~> 0' 
  s.add_dependency 'rspec'         , '~> 0'
  s.add_dependency 'tux'           , '~> 0'
  s.add_dependency 'radix62'       , '~> 0'
  s.add_dependency 'parslet'       , '~> 0'
  s.add_dependency 'activesupport' , '~> 5'
  s.add_dependency 'i18n'          , '~> 0'

  # s.rubyforge_project = "vgtd"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `ls bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
