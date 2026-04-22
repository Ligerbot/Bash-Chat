#!/bin/bash
if [ -e $HOME/.local/chatapp/server ]; then
	server=$(cat $HOME/.local/chatapp/server)
else
	read -p "Chat Server IP Address: " server
	mkdir -p $HOME/.local/chatapp
	echo $name > $HOME/.local/chatapp/server
fi

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
#            echo
        fi
    done

    rm -f "$tmpfile"
}
getmsg() {
	while true; do
#		messages=$(curl -s -X POST \
#			-H "Content-Type: application/json" \
#			-d '{"name": "'"$name"'"}' \
#			http://192.168.1.195:10101/chat | perl -pe 's/\\n/\n/g' | dc)
		file=$(mktemp)
		curl -s -X POST -H "Content-Type: application/json" -d '{"name": "'"$name"'"}' http://$server:10101/chat | perl -pe 's/\\n/\n/g' | dc > $file
		clear
		cat $file
		sleep 1
	done
}

clear
getmsg
