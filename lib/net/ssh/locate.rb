require "net/ssh/locate/version"
require "thor/group"  
require "sys/proctable"

module Net
  module SSH
    module Locate
      class App < Thor::Group
        include Thor::Actions
        
        def locate_agent
          @scanner = Scanner.new
          @scanner.scan
        end
        
        def print_shell_commands
          if usingFish?
            fishOutput
          else
            bashOutput
          end
          return unless @scanner.found?
        end

        private
          def usingFish?
            passwdEntry = `getent passwd #{ENV['USER']}`
            passwdEntry =~ /fish$/
          end

          def bashOutput
            print "SSH_AUTH_SOCK=#{@scanner.agentSocket};"
            puts "export SSH_AUTH_SOCK;"
            print "SSH_AGENT_PID=#{@scanner.agentPID};"
            puts "export SSH_AGENT_PID;"
            puts "echo Agent pid #{@scanner.agentPID};"
          end          

          def fishOutput
            puts "set -x SSH_AUTH_SOCK #{@scanner.agentSocket}"
            puts "set -x SSH_AGENT_PID #{@scanner.agentPID}"
          end          
      end
  
      class Scanner
        
        attr_reader :agentSocket, :agentPID, :found
        
        def scan
          @found = false
          procs = Sys::ProcTable.ps.select do 
            |p|
            (p.cmdline =~ /ssh-agent/) && !(p.cmdline =~ /--session=ubuntu/) && !(p.state=='Z')
          end
          return if procs.empty?
          p=procs.first
          p.cmdline =~ /ssh-agent\s-a ([-.a-zA-Z0-9_\/]+)/
          return if !$~
          @found = true
          @agentSocket = $1
          @agentPID = p.pid
        end
  
        def found?
          @found
        end

      end

    end
  end
end
