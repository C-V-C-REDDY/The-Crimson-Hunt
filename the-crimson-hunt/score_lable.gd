extends Label

func _ready():
	# Update the text immediately at start
	text = "Kills: " + str(Global.kills)
	
	# Tell the script to listen to the Global "score_changed" signal
	Global.score_changed.connect(_on_score_updated)

func _on_score_updated():
	# This runs every time Global.add_kill() is called!
	text = "Kills: " + str(Global.kills)
