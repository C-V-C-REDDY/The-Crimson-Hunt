extends CharacterBody2D


var health = 2
var is_elite = false
const ORB_SCENE = preload("res://experience_orb.tscn")
@onready var player  = get_node("/root/Game/Player")

func _ready() -> void:
	%Slime.play_walk()
	if is_elite:
		%Slime.modulate = Color(2.0 , 0.3 , 0.3)
		scale = Vector2(1.5 , 1.5)
		
		health = 5
	else:
		%Slime.modulate = Color(0.8 , 0.1 , 1.0)

func _process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var distance = global_position.distance_to(player.global_position)
		if distance > 1200:
			queue_free()




func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 200.0
	move_and_slide()

func take_damage():
	health -= 1
	%Slime.play_hurt()
	if health <= 0:
		Global.add_kill()
		queue_free()
		die.call_deferred()
		
	if health == 0:
		
		queue_free()
		const SMOKE_EXPLOSION = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_EXPLOSION.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		
func die():
	if is_elite == true:
		var new_orb = ORB_SCENE.instantiate()
		get_tree().current_scene.add_child(new_orb)
		new_orb.global_position = global_position
		print("ELite died!cDropping orbs.")
	queue_free()
