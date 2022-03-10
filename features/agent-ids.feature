Feature: Agent IDs
  In order to connect to remote services in a secure and efficient manner
  As a modern sysadmin who values machine resources and human time
  I want to connect to a single ssh agent, launched a long time ago in a shell far far away
  
  Scenario: Locate a running agent
    Given an ssh agent has been launched without parameters
    Given the user's shell is Bash
    When I run `ssh-locate`
    Then the output should contain "SSH_AUTH_SOCK="
    And the output should contain "export SSH_AUTH_SOCK;"
    And the output should contain "SSH_AGENT_PID="
    And the output should contain "export SSH_AGENT_PID;"
    And the output should contain the correct agent PID
    And the output should contain the correct agent socket
    
  Scenario: No agent is running or locatable
    Given no agent is running
    When I run `ssh-locate`
    Then the output should be empty
    
@focus
  Scenario: Locate an agent that shows its socket in the command line
    Given an ssh agent has been launched with a specific socket
    Given the user's shell is Bash
    When I run `ssh-locate`
    Then the output should contain "SSH_AUTH_SOCK="
    And the output should contain "export SSH_AUTH_SOCK;"
    And the output should contain "SSH_AGENT_PID="
    And the output should contain "export SSH_AGENT_PID;"
    And the output should contain the correct agent PID
    And the output should contain the correct agent socket

  Scenario: Recognize and honor the agent managed by Ubuntu
    Given an ssh agent has been launched in my Ubuntu session
    When I run `ssh-locate`
    Then the output should contain "SSH_AUTH_SOCK="
    And the output should contain "export SSH_AUTH_SOCK;"
    And the output should contain "SSH_AGENT_PID="
    And the output should contain "export SSH_AGENT_PID;"
    And the output should contain the correct agent PID
    And the output should contain the correct agent socket

  Scenario: Ignore agents run by someone else
    Given an ssh agent is running for another user
    And no ssh agent is running for me
    When I run `ssh-locate`
    Then the output should contain "no agent found"

  Scenario: Support Fish
    Given an ssh agent has been launched with a specific socket
    Given the user's shell is Fish
    When I run `ssh-locate`
    Then the output should contain "set -x SSH_AUTH_SOCK"
    And the output should contain "set -x SSH_AGENT_PID"
    And the output should contain the correct agent PID
    And the output should contain the correct agent socket

   Scenario: Support EMACS
    Given an ssh agent has been launched with a specific socket
    When I run `ssh-locate --emacs`
    Then the output should contain "(setenv \"SSH_AUTH_SOCK"
    And the output should contain "(setenv \"SSH_AGENT_PID"
    And the output should contain the correct agent PID
    And the output should contain the correct agent socket
