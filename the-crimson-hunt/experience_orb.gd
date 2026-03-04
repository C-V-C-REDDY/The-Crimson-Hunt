extends Area2D

var speed = 0.0
var move_to_player = false
var player = null

func _ready():
	# This finds the player node. 
	# MAKE SURE your HappyBoo node is in a group called "player"!
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if player:
		var distance = global_position.distance_to(player.global_position)
		
		# 1. DETECTION: If player is within 200 pixels, start the magnet
		if distance < 200:
			move_to_player = true
			
		# 2. MOVEMENT: If magnet is on, fly toward player
		if move_to_player:
			speed += 15.0 # Acceleration makes it feel "snappy"
			global_position = global_position.move_toward(player.global_position, speed * delta)
			
			# 3. COLLECTION: If it touches the player, disappear
			if distance < 25:
				# Add XP sound or logic here later!
				queue_free()
			if distance < 30:
				if player.has_method("gain_experience"):
					player.gain_experience(1)
				queue_free()
