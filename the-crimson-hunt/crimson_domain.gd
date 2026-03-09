extends Node2D

@onready var charge_timer = $ChargeTimer
@onready var cooldown_timer = $CooldownTimer
@onready var camera = get_viewport().get_camera_2d()

var is_charging: bool = false
var has_burst_fired: bool = false 

func _process(_delta):
	# 1. Update visual effects while charging
	if is_charging:
		update_charge_effects()
		return 

	# 2. Check for activation
	if Input.is_action_just_pressed("ui_accept"): 
		if get_parent().level >= 3 and cooldown_timer.is_stopped():
			start_crimson_charge()
		elif not cooldown_timer.is_stopped():
			print("Ability on cooldown : ", int(cooldown_timer.time_left),"s remaining")
	
func start_crimson_charge():
	is_charging = true
	has_burst_fired = false 
	charge_timer.start(5.0)
	print("Domain Charging...")

func update_charge_effects():
	var progress = 1.0 - (charge_timer.time_left / charge_timer.wait_time)
	var shake_strength = progress * progress * 15.0
	if camera:
		camera.offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))

func _on_charge_timer_timeout():
	if not has_burst_fired:
		execute_crimson_burst()

func trigger_red_flash():
	# Using %AnimationPlayer (Unique Name) is a smart Godot 4 move!
	%AnimationPlayer.play("flash")

func execute_crimson_burst():
	has_burst_fired = true 
	is_charging = false    
	
	trigger_red_flash()
	
	if camera:
		camera.offset = Vector2.ZERO 
	
	var all_mobs = get_tree().get_nodes_in_group("mobs")
	print("CRIMSON BURST: Wiping ", all_mobs.size(), " mobs.")
	
	# Execute the wipe
	for mob in all_mobs:
		var distance = global_position.distance_to(mob.global_position)
		if distance < 1000:
			if mob.has_method("die"):
				mob.die()
			
				
				
	# Start the 45s cooldown AFTER the wipe is finished
	cooldown_timer.start(45.0)


func _on_cooldown_timer_timeout() -> void:
	if not has_burst_fired:
		execute_crimson_burst()
