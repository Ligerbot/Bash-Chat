mkdir -p $HOME/.local/chatapp/recipients
if [ -z "$(ls -A $HOME/.local/chatapp/recipients)" ]; then
	echo "No recipients yet"
	read -p "Recipients Name: " friendname
	read -p "Recipient Email: " friendemail
	echo "Messages will be sent to" $friendemail
	echo $friendemail > "$HOME/.local/chatapp/recipients/$friendname"
else
	list=$(ls $HOME/.local/chatapp/recipients | nl)
	echo "Choose a recipient"
	echo $list
	read -p "Recipient Name: " friendname
	if [ -e "$HOME/.local/chatapp/recipients/$friendname" ]; then
		friendemail=$(cat "$HOME/.local/chatapp/recipients/$friendemail")
	else
		echo "Nonexistant Recipient"
		exit
	fi
fi
echo "Added recipient with name" $friendname "and with email" $friendemail
curl -X POST -H "Content-Type: application/json" -d "{\"name\":\"$friendname\"}" http://$server:10101/downloadkey -o "$HOME/.local/chatapp/recipients/$friendname.gpg"
echo "Downloaded recipient public key"
if [ -e $HOME/.local/chatapp/server ]; then
	server=$(cat $HOME/.local/chatapp/server)
else
	read -p "Chat Server IP Address: " server
	echo "IP set to: " $server
	mkdir -p $HOME/.local/chatapp
	echo $server > $HOME/.local/chatapp/server
fi
clear
#do some monkey buisness with termux to make it open two terminals and run the reciever and sender
if [ -z "$TMUX" ]; then
	tmux new-session -d -s main "sh recieve.sh"
	tmux split-window -v -p 20 "sh send.sh"
	tmux attach-session -t main
	exit
fi
