# Install git

```sh
yay -S git
```

## Setup ssh key

- Generate an SSH Key pair on client machine
```sh
ssh-keygen -t ed25519 -C "your_email@example.com"
```

- Copy your public key to the server
```sh
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@your-server-ip
```

- Or manually copy it
```sh
# On Client
cat ~/.ssh/id_ed25519.pub

# On Server
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys   # paste in the public key line
chmod 600 ~/.ssh/authorized_keys
```

- Change existing repo from https to ssh
```sh
# check current origin
git remote -v

# get the ssh clone url from the git hub (should be where you get the https clone url)

# update the remote url 
git remote set-url origin <url>
```
