sudo apt-get update
sudo apt-get install -y curl git build-essential postgresql-9.2 zsh silversearcher-ag
curl -sSL https://get.rvm.io | bash -s stable
gem install bundler
chsh -s $(which zsh)
sudo rm -rf ~/.oh-my-zsh && sudo curl -L http://install.ohmyz.sh > ~/install_zsh.sh && sudo zsh ~/install_zsh.sh
