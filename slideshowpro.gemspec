# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "slideshowpro/version"

Gem::Specification.new do |s|
  s.name        = "slideshowpro"
  s.version     = Slideshowpro::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dan Hixon"]
  s.email       = ["danhixon@gmail.com"]
  s.homepage    = "http://github.com/danhixon/slideshowpro"
  s.summary     = %q{Ruby wrapper for the SlideShowPro Director API}
  s.description = %q{Ruby wrapper for the SlideShowPro Director API.}

  s.rubyforge_project = "slideshowpro"
  
  s.add_dependency('crack', '~> 0.1.8')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
