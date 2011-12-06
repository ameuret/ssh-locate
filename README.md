ssh-locate
==========
"!https://secure.travis-ci.org/[ameuret]/[ssh-locate].png!":http://travis-ci.org/[ameuret]/[ssh-locate]
  
  A command line tool that helps you locate and contact a SSH agent launched in a separate session.
  
Features
--------
  - output is fully compatible with openSSH:

```
    SSH_AUTH_SOCK=/tmp/ssh-locate-test.15970; export SSH_AUTH_SOCK;
    SSH_AGENT_PID=12427; export SSH_AGENT_PID;
    echo Agent pid 12427;
```
  
Installation
------------
  
    gem install ssh-locate
  
Usage
-----
  
Launch your SSH agent and tell it to use a specific socket file with the -a option:

    ssh-agent -a /tmp/deployer-38us9f

In a later shell (or any process running for the user owning the agent):

    $ eval `ssh-locate`
    Agent pid 13457

Caveat
------

`ssh-locate` only reports the first agent found in the process table. If you have a scenario where you would like to be more specific, let me known and I can extend the selectivity. I just do not need that right now.

TODO
----
As the YAGNI wisdom tells us not to fantasize requirements, here are some potentially useful things that are not implemented yet:

  - Be aware of the agent launched by Ubuntu
  - Have a more sensible output if no agent was found
