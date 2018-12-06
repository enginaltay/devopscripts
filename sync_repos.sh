rm -r .git
git config --global user.name "yourusername"
git config --global user.email "youremailadress"

git init
git config core.sshCommand "ssh -v -i /{path to id rsa under .ssh}"
git remote add origin ssh://git@{remote ip address:{port}/home/{repoaddress.git}
git add .
git commit -m "Syncing..."
git push -v -u origin HEAD:${Branch}
