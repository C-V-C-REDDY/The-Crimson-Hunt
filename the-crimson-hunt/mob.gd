extends CharacterBody2D

var health = 2
var is_elite = false
const ORB_SCENE = preload("res://experience_orb.tscn")
@onready var player  = get_node("/root/Game/Player")
var speed = 200.0
var is_dying = false
func _ready() -> void:
	%Slime.play_walk()
	if is_elite:
		%Slime.modulate = Color(2.0 , 0.3 , 0.3)
		scale = Vector2(1.5 , 1.5)
		speed = 375.0
		health = 5
	else:
		%Slime.modulate = Color(0.8 , 0.1 , 1.0)
		speed = 200.0

func _process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var distance = global_position.distance_to(player.global_position)
		if distance > 1200:
			queue_free()

func play_hit_sfx():
	%HitSound.pitch_scale = randf_range(0.9, 1.1)
	%HitSound.play()
	
func play_death_sfx():
	%DeathSound.pitch_scale = randf_range(0.7, 1.4)
	%DeathSound.play()
	%Slime.visible = false
	set_physics_process(false)
	#$CollisionShape2D.disabled = true
	await %DeathSound.finished
	queue_free()


func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
func take_damage():
	if is_dying:
		return
	health -= 1
	%Slime.play_hurt()
	play_hit_sfx()
	
	if health <= 0:
		# 1. Handle Global stats and Orbs BEFORE the node is deleted
		is_dying = true
		Global.add_kill()
		if is_elite:
			var new_orb = ORB_SCENE.instantiate()
			get_tree().current_scene.call_deferred("add_child", new_orb)
			new_orb.global_position = global_position
			print("Elite died! Dropping orbs.")
		
		# 2. Spawn the smoke effect
		const SMOKE_EXPLOSION = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_EXPLOSION.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		
		# 3. Trigger the death sound (which handles its own queue_free)
		play_death_sfx()


func die():
	if is_dying:
		return
	is_dying = true
	if is_elite:
		var new_orb = ORB_SCENE.instantiate()
		get_tree().current_scene.add_child(new_orb)
		new_orb.global_position = global_position
	Global.add_kill()
	const SMOKE_EXPLOSION = preload("res://smoke_explosion/smoke_explosion.tscn")
	var smoke = SMOKE_EXPLOSION.instantiate()
	get_parent().add_child(smoke)
	smoke.global_position = global_position
	play_death_sfx()
	
