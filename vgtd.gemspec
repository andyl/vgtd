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

  s.add_dependency('rake')
  s.add_dependency('rspec')
  s.add_dependency('tux')
  s.add_dependency('radix62')
  s.add_dependency('parslet')
  s.add_dependency('activesupport')
  s.add_dependency('i18n')

  # s.add_dependency('wirble')
  # s.add_dependency('drx')
  # s.add_dependency('hirb')
  # s.add_dependency('interactive_editor')
  # s.add_dependency('awesome_print')
  # s.rubyforge_project = "vgtd"
  # s.files         = `git ls-files`.split("\n")
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `ls bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
