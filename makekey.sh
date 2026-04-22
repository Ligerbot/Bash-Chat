#check to see if we have a server set already
if [ -e $HOME/.local/chatapp/server ]; then
	server=$(cat $HOME/.local/chatapp/server)
else
	read -p "Chat Server IP Address: " server
	mkdir -p $HOME/.local/chatapp
	echo $server > $HOME/.local/chatapp/server
fi
#read the users name if any
if [ -e $HOME/.local/chatapp/name ]; then
	name=$(cat $HOME/.local/chatapp/name)
else
	read -p "Your Name: " name
	mkdir -p $HOME/.local/chatapp
	echo $name > $HOME/.local/chatapp/name
fi
#get the users email
if [ -e $HOME/.local/chatapp/email ]; then
	email=$(cat $HOME/.local/chatapp/email)
else
	echo "Email Address is required to make a GPG key, enter anything here"
	read -p "Your Email Address: " email
	mkdir -p $HOME/.local/chatapp
	echo $email > $HOME/.local/chatapp/email
fi
#get a passphrase if any
read -p "Password for key (leave blank for none): " password
passwdOP="not chosen"
if [ -z "$password" ]; then
	echo "Continuing with no password"
	passwdOP="%no-protection"
else
	passwdOP="Passphrase: $password"
fi
echo $passwdOP
#make the key with this new info now...
gpg --batch --gen-key <<EOF
Key-Type: RSA
Key-Length: 4096
Name-Real: $name
Name-Email: $email
Expire-Date: 0
$passwdOP
%commit
EOF
gpg --export --armor "$email" > $HOME/.local/chatapp/public.gpg
#gpg --export-secret-keys --armor "$email" > $HOME/.local/chatapp/private.gpg
gpg --batch --pinentry-mode loopback --passphrase "$password" --export-secret-keys --armor "$email" > $HOME/.local/chatapp/private.gpg
curl -X POST -F "file=@$HOME/.local/chatapp/public.gpg" -F "data={\"name\":\"$name\"}" http://$server:10101/uploadkey
