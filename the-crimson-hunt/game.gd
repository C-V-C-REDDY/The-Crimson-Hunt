extends Node2D

@onready var timer = $Timer
@onready var game_over: CanvasLayer = %GameOver

func spawn_mob():
	var new_mob = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)

func _on_timer_timeout() -> void:
	spawn_mob()

func _on_player_health_depleted() -> void:
	trigger_game_over()
	get_tree().paused = true

var time_passed = 0.0
func _process(delta: float) -> void:


	time_passed += delta
	if time_passed < 30:
		timer.wait_time = 2.0
	elif time_passed < 60:
		timer.wait_time = 1.0
	else:
		timer.wait_time = 0.5


func _on_button_pressed() -> void:
	get_tree().paused = false
	Global.kills = 0
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

func _on_elite_timer_timeout() -> void:
	var slime_scene = preload("res://mob.tscn")
	var elite_slime = slime_scene.instantiate()
	
	elite_slime.is_elite = true
	var spawn_pos = Vector2(randf_range(-500 , 500) , randf_range(-500 , 500))
	elite_slime.global_position = %Player.global_position + spawn_pos
	add_child(elite_slime)

func trigger_game_over():
	print("DEATH TRIGGERED")
	Engine.time_scale = 0.3
	%GameOver.visible = true

	if %GameOverUI.has_animation("ShowGameOver"):
		%GameOverUI.play("ShowGameOver")
	else:
		print("ERROR: ANIMATION NOT FOUND!")





func _on_quit_button_pressed() -> void:
	get_tree().quit()
