extends Node2D

@onready var charge_timer = $ChargeTimer
@onready var cooldown_timer = $CooldownTimer
@onready var camera = get_viewport().get_camera_2d()
@onready var crimson_logo: TextureRect = $"../../UI/CrimsonLogo"
@onready var texture_progress_bar: TextureProgressBar = $"../../UI/CrimsonLogo/TextureProgressBar"
@onready var ready_animation: AnimationPlayer = $"../../UI/CrimsonLogo/ReadyAnimation"

var is_charging: bool = false
var has_burst_fired: bool = false 

func _process(_delta):
	# 1. Update visual effects while charging
	if is_charging:
		update_charge_effects()
		update_ui_display()
		return 

	# 2. Check for activation
	if Input.is_action_just_pressed("ui_accept"): 
		if get_parent().level >= 3 and cooldown_timer.is_stopped():
			start_crimson_charge()
			
		elif not cooldown_timer.is_stopped():
			print("Ability on cooldown : ", int(cooldown_timer.time_left),"s remaining")
	update_logo_visuals()
	update_ui_display()
func start_crimson_charge():
	is_charging = true
	has_burst_fired = false 
	charge_timer.start(5.0)
	%RumbleSFX.play()
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
func update_logo_visuals():
	if get_parent().level < 3 or not cooldown_timer.is_stopped():
		crimson_logo.modulate = Color(0.3 , 0.3 , 0.3 ,0.5)
		stop_ready_animation()
	else:
		crimson_logo.modulate = Color(2.5 , 0.2 , 0.2)
		play_ready_animation()
func update_ui_display():
	if not texture_progress_bar: return
	texture_progress_bar.tint_under = Color(0.1 , 0.1 , 0.1 , 0.6)
	if not cooldown_timer.is_stopped():
		texture_progress_bar.value = cooldown_timer.time_left
		texture_progress_bar.tint_progress = Color(2.0 , 0 , 0 , 1.0)
	elif is_charging:
		texture_progress_bar.value = 0
		texture_progress_bar.tint_under = Color(0 , 0, 0 , 1.0)
	elif get_parent().level >= 3:
		texture_progress_bar.value = 0
		texture_progress_bar.tint_progress = Color(2.0 , 0.2 , 0.2 , 1.0)
		texture_progress_bar.tint_under = Color(0.4 , 0 , 0 , 1.0)
	else:
		texture_progress_bar.value = 0
		texture_progress_bar.tint_under = Color(0.2 , 0.2 , 0.2 , 0.3)
func play_ready_animation():
	ready_animation.play("Ready")
func stop_ready_animation():
	ready_animation.stop()

	

func _on_cooldown_timer_timeout() -> void:
	
	if not has_burst_fired:
		execute_crimson_burst()
