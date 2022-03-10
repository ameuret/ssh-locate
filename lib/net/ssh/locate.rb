require 'net/ssh/locate/version'
require 'thor/group'
require 'sys/proctable'
require 'English'

module Net
  module SSH
    module Locate
      class App < Thor::Group
        include Thor::Actions
        def self.banner
          <<-LONGDESC
ssh-locate will search for a running ssh-agent and output the environment
  variables needed to contact it.

  To make sure that you're selecting the agent you launched and not the agent
  launched by your Desktop Environment, you must use the -a option to specify
  a socket path:

  $ ssh-agent -a /tmp/zed
  SSH_AUTH_SOCK=/tmp/zed; export SSH_AUTH_SOCK;
  SSH_AGENT_PID=1908155; export SSH_AGENT_PID;
  echo Agent pid 1908155;

  Then later in another shell instance:

  $ ssh-locate
  SSH_AUTH_SOCK=/tmp/zed; export SSH_AUTH_SOCK;
  SSH_AGENT_PID=1908155; export SSH_AGENT_PID;
  echo Agent pid 1908155;
          LONGDESC
        end

        class_option :emacs, type: :boolean, desc: 'Output EMACS LISP to execute in EMACS'

        def locate_agent
          @scanner = Scanner.new
          @scanner.scan
        end

        def print_shell_commands
          return unless @scanner.found?

          if options[:emacs]
            emacsOutput
          elsif usingFish?
            fishOutput
          else
            bashOutput
          end
        end

        private

        def usingFish?
          # TODO: This is far from perfect. Launching a secondary shell e.g. zsh from fish would
          # still show the SHELL env var as /usr/bin/fish
          ENV['SHELL'] =~ /fish/
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

        def emacsOutput
          puts "(setenv \"SSH_AUTH_SOCK\" \"#{@scanner.agentSocket}\")"
          puts "(setenv \"SSH_AGENT_PID\" \"#{@scanner.agentPID}\")"
        end
      end

      class Scanner
        attr_reader :agentSocket, :agentPID, :found

        def scan
          @found = false
          procs = Sys::ProcTable.ps(smaps: false, cgroup: false).select do
            |p|
            res = p.cmdline =~ /ssh-agent/ && p.cmdline !~ /--session=ubuntu/ && p.state != 'Z'
            res
          end
          return if procs.empty?

          p = procs.first
          p.cmdline =~ /ssh-agent\s-a ([-.a-zA-Z0-9_\/]+)/
          return unless $LAST_MATCH_INFO

          @found = true
          @agentSocket = $LAST_MATCH_INFO[1]
          @agentPID = p.pid
        end

        def found?
          @found
        end

      end

    end
  end
end
