#!/bin/sh

# remove old (if any)
sed -i '/nvm/Id' /etc/skel/.bashrc
rm -rf /opt/nvm/

# install new
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
mv /root/.nvm/ /opt/nvm
sed -i '/nvm/Id' ~/.bashrc
sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' /etc/skel/.bashrc		# odstran posledne prazdne riadky

cat <<EOT >> /etc/skel/.bashrc

# NVM
export NVM_DIR="/opt/nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion

EOT

mkdir /opt/nvm/alias
chmod 777 /opt/nvm/alias
mkdir /opt/nvm/.cache
chmod 777 /opt/nvm/.cache
mkdir /opt/nvm/versions
chmod 777 /opt/nvm/versions
mkdir /opt/nvm/versions/node
chmod 777 /opt/nvm/versions/node

