# Dev Container Notes

Collection of Dev Container notes and Runme playbooks.

## Life Cycle Commands

To start the Dev Container:

```bash { background=false category=devcontainer closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=devcontainer-up promptEnv=true terminalRows=10 }
./.devcontainer/scripts/dc-up
```

To run a shell in the Dev Container:

```bash { background=false category=devcontainer closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=devcontainer-run promptEnv=true terminalRows=10 }
./.devcontainer/scripts/dc-run
```

To stop the Dev Container:

```bash { background=false category=devcontainer closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=devcontainer-down promptEnv=true terminalRows=10 }
./.devcontainer/scripts/dc-down
```

To destroy the Dev Container:

```bash { background=false category=devcontainer closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=devcontainer-destroy promptEnv=true terminalRows=10 }
./.devcontainer/scripts/dc-destroy
```

To list the Dev Containers:

```bash { background=false catgory=devcontainer closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=devcontainer-list promptEnv=true terminalRows=10 }
./.devcontainer/scripts/dc-list
```

## Using Dev Containers

Notes:

- Since the Dev Containers have to be manually stopped or destroyed, if you detach
from your tmux shell before exiting the container's shell, you'll be able to
resume from where you left off on your next session.

Example session:

```bash
$ ./.devcontainer/scripts/dc-run
+ [[ -f ./.devcontainer/scripts/data.tmp ]]
+ source ./.devcontainer/scripts/data.tmp
++ devcontainer_username=user
++ devcontainer_password='random_sudo_password'
++ devcontainer_uid=1000
++ devcontainer_gid=1000
+ printf '\n'

+ ./.devcontainer/scripts/dc-list
ID            Names                   Image                          State    Status       RunningFor
124e3d92a383  user_ansible-workspace  user/ci-generic-rpidev:latest  running  Up 10 hours  10 hours ago
+ printf '\n'

+ [[ '' == --root ]]
+ devcontainer exec --workspace-folder /home/user/git_user/rpi-pico-workspace sudo -u user -i

$ ssh-agent | tee /tmp/ssh-agent-settings.txt
SSH_AUTH_SOCK=/tmp/ssh-XXXXXXsfjwTz/agent.47126; export SSH_AUTH_SOCK;
SSH_AGENT_PID=47126; export SSH_AGENT_PID;
echo Agent pid 47126;

$ source /tmp/ssh-agent-settings.txt
Agent pid 47126

$ ssh-add ~/.ssh/id_key
ssh-add ~/.ssh/id_rsa-user@email.com
Enter passphrase for /home/user/.ssh/id_rsa-user@email.com: xxx
Identity added: /home/user/.ssh/id_rsa-user@email.com (user@email.com)

$ ssh-add -L
ssh-rsa xxx= user@email.com

$ cd git_"${USER}"/rpi-pico-workspace/

$ tmux  # now all the shells will have an ssh-agent config and use the same PWD
```

Reattaching to an existing session:

```bash
./.devcontainer/scripts/dc-run

tmux a
```
