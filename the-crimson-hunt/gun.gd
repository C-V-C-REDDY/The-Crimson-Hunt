extends Area2D

func _physics_process(_delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)


func shoot():
	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	%muzzel_flash.enabled = true
	await get_tree().create_timer(0.05).timeout
	%muzzel_flash.enabled = false
	%ShootingPoint.add_child(new_bullet)
	position.x = -20
	var tween = create_tween()
	tween.tween_property(self, "position:x" , 0 , 0.1).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)


func _on_timer_timeout() -> void:
	shoot()
