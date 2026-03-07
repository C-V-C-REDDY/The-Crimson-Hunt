extends Node2D

@onready var charge_timer = $ChargeTimer
@onready var cooldown_timer = $CooldownTimer
@onready var camera = get_viewport().get_camera_2d()

var is_charging: bool = false
var has_burst_fired: bool = false # This is our new "Gatekeeper"

func _process(_delta):
	# 1. Update visual effects while charging
	if is_charging:
		update_charge_effects()
		return # Stop here so we don't check for Input while already busy

	# 2. Check for activation
	if Input.is_action_just_pressed("ui_accept"): 
		if get_parent().level >= 3 and cooldown_timer.is_stopped():
			start_crimson_charge()

func start_crimson_charge():
	is_charging = true
	has_burst_fired = false # Reset the gatekeeper
	charge_timer.start(5.0)
	print("Domain Charging...")

func update_charge_effects():
	var progress = 1.0 - (charge_timer.time_left / charge_timer.wait_time)
	var shake_strength = progress * progress * 15.0
	if camera:
		camera.offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))

func _on_charge_timer_timeout():
	# Only fire if we haven't fired yet
	if not has_burst_fired:
		execute_crimson_burst()

func execute_crimson_burst():
	has_burst_fired = true # Close the gate immediately
	is_charging = false    # Stop the shake logic
	
	if camera:
		camera.offset = Vector2.ZERO # Snap camera back
	
	var all_mobs = get_tree().get_nodes_in_group("mobs")
	print("CRIMSON BURST: Wiping ", all_mobs.size(), " mobs.")

	for mob in all_mobs:
		var distance = global_position.distance_to(mob.global_position)
		if distance < 1000:
			if mob.has_method("die"):
				mob.die()
			else:
				mob.queue_free()
				
	cooldown_timer.start(45.0) # Start the 45s wait
