clear
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
                friendemail=$(cat "$HOME/.local/chatapp/recipients/$friendname")
        else
                echo "Nonexistant Recipient"
                exit
        fi
fi
echo "Added recipient with name" $friendname "and with email" $friendemail

#check to see if we have a server set already
if [ -e $HOME/.local/chatapp/server ]; then
	server=$(cat $HOME/.local/chatapp/server)
else
	read -p "Chat Server IP Address: " server
	mkdir -p $HOME/.local/chatapp
	echo $server > $HOME/.local/chatapp/server
fi

#see if name is set
if [ -e $HOME/.local/chatapp/name ]; then
	name=$(cat $HOME/.local/chatapp/name)
else
	read -p "Your Name: " name
	mkdir -p $HOME/.local/chatapp
	echo $name > $HOME/.local/chatapp/name
fi

encrypt() {
	encrypted=$(echo "$1" | gpg --encrypt --armor -r "$friendemail" | tr -d '\n')
}

send() {
	#this is for sending a msg
	echo -ne "\nEnter your message\n"
	read -p "> " message
	if [[ "$message" == "" ]]; then
		true
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
