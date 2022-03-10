Given /^an ssh agent has been launched without parameters$/ do
  pending
end

Given /^an ssh agent has been launched with a specific socket$/ do
  @agentIO = IO.popen('ssh-agent -a /tmp/ssh-locate-test.15970')
  @agentOutput = @agentIO.read
  @agentIO.close
  @agentPID = @agentOutput[/PID=(\d+)/,1].to_i
  @agentSocket = @agentOutput[/SOCK=([\w\-._\/]+)/,1]
  # The agent is shutdown in the 'after' hook
end

Given /^an SSH agent has been launched in my Ubuntu session$/ do
  pending
end

Given /^no agent is running$/ do
  @agentPID=nil
  @agentSocket=nil
end

Given /^an ssh agent is running for another user$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^no ssh agent is running for me$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the output should be empty$/ do
  expect(all_output).to be_empty
end

Then /^the output should contain the correct agent PID$/ do
  expect(all_output).to include @agentPID.to_s
end

Then /^the output should contain the correct agent socket$/ do
  expect(all_output).to  include @agentSocket.to_s
end

Given("the user's shell is Fish") do
  set_environment_variable('SHELL', 'fish')
end

Given("the user's shell is Bash") do
  set_environment_variable('SHELL', 'bash')
end

