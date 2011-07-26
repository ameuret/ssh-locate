# -*- encoding: utf-8 -*-
$:.push File.expand_path("lib", File.dirname(__FILE__))
require "net/ssh/locate/version"

Gem::Specification.new do |s|
  s.name        = "ssh-locate"
  s.version     = Net::SSH::Locate::VERSION
  s.authors     = ["Arnaud Meuret"]
  s.email       = ["arnaud@meuret.name"]
  s.homepage    = ""
  s.summary     = %q{A tool (+ a Ruby lib) to locate a running SSH agent}
  s.description = %q{A CLI tool and its associated Ruby library that help you locate and reconnect to a running SSH agent. Useful in automation scenarios where multiple processes must repeatedly open SSH connections leveraging a one-time authentication pass}

  s.rubyforge_project = "ssh-locate"
  
  s.add_dependency "sys-proctable"
  s.add_dependency "thor"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
