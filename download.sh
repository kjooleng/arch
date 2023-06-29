curl -o install.sh -SL https://bit.ly/42Z4SsR
#curl -o time.sh -SL https://bit.ly/3B6BGEw
curl -o wine.sh -SL https://bit.ly/3XrNsnz

curl -o locale.gen -SL https://bit.ly/46unILs
curl -o pacman.conf -SL https://bit.ly/44iJTCR
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
