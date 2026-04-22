# Bash Chat

## How it works

This is my attempt at creating an instant messaging service using a bash script for the client and a python script for the server. It requires port 10101 to be open.
The messages are encrypted using your GPG key made from the `makekey.sh` script. They are stored on the server also encrypted and they are only decrypted when being printed to the other persons terminal.

## Starting

To start, first run `bash makekey.sh` and then when that finishes run `bash client.sh`. 

If you would like to run a reciever only just run `bash recieve.sh`.
Similarly, if you want to run the sending prompt only for some reason, run `bash send.sh`.

## Running your own server

Make sure that the python3 libraries `flask` and `flask_cors` are installed. Then run `python3 backend.py`. Remember that this uses port 10101 for everything and for your chat service to be able to be accessed outside of the local network you need to forward that port. When you first run `client.sh`, it will prompt you for the server ip. Just enter the ip address or domain name without https:// or any such prefixes.
Before running you need to modify the script to use the path to the directory where this repo is located. Otherwise it will fail.
