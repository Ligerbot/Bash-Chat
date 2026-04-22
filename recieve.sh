#!/bin/bash
#check to see if there is a server set already
if [ -e $HOME/.local/chatapp/server ]; then
	server=$(cat $HOME/.local/chatapp/server)
	#if so just store the ip to a variable
else
	#otherwise get the server ip
	read -p "Chat Server IP Address: " server
	mkdir -p $HOME/.local/chatapp
	echo $name > $HOME/.local/chatapp/server
fi

#the function dc was made with help by claude. everything else here is my own work.
dc() {
	local tmpfile=$(mktemp)
	while IFS= read -r line; do
		if [[ "$line" == *"-----BEGIN PGP MESSAGE-----"* && "$line" == *"-----END PGP MESSAGE-----"* ]]; then
			local body="${line#*-----BEGIN PGP MESSAGE-----}"
			body="${body%-----END PGP MESSAGE-----*}"
			{
				echo "-----BEGIN PGP MESSAGE-----"
				echo "$body" | fold -w 64
				echo "-----END PGP MESSAGE-----"
			} > "$tmpfile"
			gpg --decrypt "$tmpfile" 2>/dev/null
		fi
	done
	rm -f "$tmpfile"
}
getmsg() {
	while true; do
		file=$(mktemp) #get a temporary file
		#the entire repo is basically a fancy wrapper for this command:
		curl -s -X POST -H "Content-Type: application/json" -d '{"name": "'"$name"'"}' http://$server:10101/chat | perl -pe 's/\\n/\n/g' | dc > $file #pipe all the messages to this temporary file.
		clear
		cat $file
		rm $file #remove the file so the encrypted messages aren't stored anywhere
		sleep 1
		#clear the terminal, paste the file, then wait.
		#we add the messages to a file instead of printing them directly because printing it directly takes a small amount of time for each message so it looks like a waterfall of text. storing it to a file then pasting it to the terminal is better because it all shows up at once.
	done
}

getmsg
