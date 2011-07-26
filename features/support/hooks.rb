# This file contains Cucumber hooks.
# It gets required automatically by Cucumber just because it has a .rb
# extension and resides under features/

Before do
end

After do
   if @agentIO
     Process.kill("TERM", @agentPID)
   end
end
