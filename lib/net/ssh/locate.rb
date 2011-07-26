require "net/ssh/locate/version"
require "thor/group"  
require "sys/proctable"

module Net
  module SSH
    module Locate
      class App < Thor::Group
        include Thor::Actions
        
        def locate_agent
          procs=Sys::ProcTable.ps.select do 
            |p|
            (p.cmdline =~ /ssh-agent/) && !(p.cmdline =~ /--session=ubuntu/) && !(p.state=='Z')
          end
          return if procs.empty?
          p=procs.first
          p.cmdline =~ /ssh-agent\s-a ([-.a-zA-Z0-9_\/]+)/
          return if !$~
          @agentSocket = $1
          @agentPID = p.pid
        end
        
        def print_shell_commands
          return if (!@agentPID || !@agentSocket)
          print "SSH_AUTH_SOCK=#{@agentSocket}; "
          puts "export SSH_AUTH_SOCK;"
          print "SSH_AGENT_PID=#{@agentPID}; "
          puts "export SSH_AGENT_PID;"
          puts "echo Agent pid #{@agentPID};"
        end
      end
    end
  end
end
