clear
if [ -e $HOME/.local/chatapp/server ]; then
	server=$(cat $HOME/.local/chatapp/server)
else
	read -p "Chat Server IP Address: " server
	mkdir -p $HOME/.local/chatapp
	echo $name > $HOME/.local/chatapp/server
fi

#see if name is set
if [ -e $HOME/.local/chatapp/name ]; then
	name=$(cat $HOME/.local/chatapp/name)
else
	read -p "Your Name: " name
	mkdir -p $HOME/.local/chatapp
	echo $name > $HOME/.local/chatapp/name
fi
#email detect
if [ -e $HOME/.local/chatapp/email ]; then
	email=$(cat $HOME/.local/chatapp/email)
else
	read -p "Your Email: " email
	mkdir -p $HOME/.local/chatapp
	echo $name > $HOME/.local/chatapp/email
fi

encrypt() {
	encrypted=$(echo "$1" | gpg --encrypt --armor -r "$email" | tr -d '\n')
#	echo $encrypted
}

send() {
	#this is for sending a msg
	echo -ne "\nEnter your message\n"
#	read -t 2 -p "> " message
	read -p "> " message
	if [[ "$message" == "" ]]; then
		true
#               echo -ne "\e[31m\nMessage Empty\n\e[0m"
	else
		echo "Encrypting Message"
		encrypt "[$name] $message"
		echo "Sending" $message "as an encrypted message."
		echo "Data is {\"message\": \"$encrypted\", \"name\": \"$name\"}"
		result=$(curl -s -X POST \
			-H "Content-Type: application/json" \
			-d "{\"message\": \"$encrypted\", \"name\": \"$name\"}" \
			http://$server:10101/send)
		if [[ "$result" == '{"status":"success"}' ]]; then
			true
		else
			echo $result
			exit 1
		fi
	fi
}

while true; do
	clear
	send
done
