from flask import *
import time
import os
path = "path to this repo ending with /"
def messagefile(data):
	curtime = time.strftime("%m-%d-%Y")
	if os.path.exists(path + "data/msgfile-" + curtime + ".log"):
		print("File exists; appending to it")
		with open(path + "data/msgfile-" + curtime + ".log", "a") as file:
			file.write(data + "\\n")
			file.close()
	else:
		print("Making file " + path + "data/msgfile-" + curtime + ".log")
		with open(path + "data/msgfile-" + curtime + ".log", "w") as file:
			file.write(data + "\\n")
			file.close()
	print("Data stored in " + path + "data/msgfile-" + curtime + ".log")

app = Flask("PGP encrypted chat app which I couldn't make a good name for")
#wouldn't the abbreviation be PGPECAWICMAGNF then?

actualrealtime = str(time.strftime("%H:%M:%S-%m-%d-%Y"))
messagefile("Server started at " + actualrealtime)

@app.route("/send", methods=["POST"])
def send():
	actualrealtime = str(time.strftime("%H:%M:%S-%m-%d-%Y"))
	print(actualrealtime)
	if request.method == "POST": #this should be only method allowed unless I add something later
		print("Method used was POST. Should be an incoming message")
		message = request.get_json()
		text = str(message.get("message"))
		name = str(message.get("name"))
#		messagefile(actualrealtime + " [" + name + "] " + text)
		messagefile(text)
		return jsonify({
			"status": "success"
		})
	return jsonify({
	"status": "nonexistant",
	"message": "Send a POST request with data"
	})

@app.route("/chat", methods=["POST"])
def chat():
	curtime = time.strftime("%m-%d-%Y")
	print("Messages list retrieved")
	with open(path + "data/msgfile-" + curtime + ".log", "r") as file:
		messages = file.read()
		file.close()
	print(str(messages))
	return messages, 200, {"Content-Type": "text/plain"}

app.run(host="0.0.0.0", port=10101, debug=False)
