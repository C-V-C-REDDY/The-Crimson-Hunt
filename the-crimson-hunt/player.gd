extends CharacterBody2D


func _physics_process(_delta):
	var direction = Input.get_vector("left" , "right" , "up" , "down" )
	velocity = direction * 600
	move_and_slide()
	
	if velocity.length() > 0.0:
		get_node("HappyBoo").play_walk_animation()
	else:
		get_node("HappyBoo").play_idle_animation()
