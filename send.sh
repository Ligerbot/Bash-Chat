clear
#check to see if we have a server set already
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
#check for email
#Technically this is only required for the makekey.sh file.
if [ -e $HOME/.local/chatapp/email ]; then
	email=$(cat $HOME/.local/chatapp/email)
else
	read -p "Your Email: " email
	mkdir -p $HOME/.local/chatapp
	echo $name > $HOME/.local/chatapp/email
fi


encrypt() {
	#... this encrypts the message to yourself...
	encrypted=$(echo "$1" | gpg --encrypt --armor -r "$email" | tr -d '\n')
	#will fix asap
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
