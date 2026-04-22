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
