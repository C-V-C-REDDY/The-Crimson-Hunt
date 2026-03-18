extends Node
@onready var animation_player: AnimationPlayer = $TextureRect/AnimationPlayer


func _ready():
	# Make sure the mouse is visible so they can click the buttons!
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	%Start.grab_focus() # So they can just hit 'Enter'
	idle_flicker_animation()


func _on_start_pressed() -> void:
	%MenuMusic.stop()
	get_tree().change_scene_to_file("res://game.tscn")
	
	
func idle_flicker_animation():
	animation_player.play("idle_flicker")

func _on_quit_pressed() -> void:
	get_tree().quit()
