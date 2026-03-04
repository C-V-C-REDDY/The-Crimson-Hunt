extends Sprite2D
func play_idle_animation():
	%AnimationPlayer.play("idle")


func play_walk_animation():
	%AnimationPlayer.play("walk")

func _ready() -> void:
	self_modulate = Color(0.2 , 0.5 , 4.0 , 1.0)
 
	# This sets the color to blue, but "overdrives" the brightness to 5.0
  
