extends Node


var kills: int = 0

func add_kill():
	kills += 1
	# This tells anyone listening that the score changed
	emit_signal("score_changed")

signal score_changed
