curl -o download.sh -SL https://bit.ly/43TNdnz
#curl -o time.sh -SL https://bit.ly/3B6BGEw
curl -o wine.sh -SL https://bit.ly/3NT0gjI

curl -o locale.gen -SL https://bit.ly/46unILs
curl -o pacman.conf -SL https://bit.ly/3JBq4yh
curl -o sudoers -SL https://bit.ly/3JAFIKc

nano install.sh

#nano time.sh

nano wine.sh

nano locale.gen

nano pacman.conf

nano sudoers


# edit locale.gen if you need to change language options
# nano locale.gen

chmod +x install.sh

#chmod +x time.sh

./install.sh 
