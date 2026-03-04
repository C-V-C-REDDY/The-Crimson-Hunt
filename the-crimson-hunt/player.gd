extends CharacterBody2D
var level = 1
var current_speed = 500.0
var speed_bost_amount = 50.0
var experience = 0
var experience_required = 2
@onready var xp_bar: ProgressBar = %XPBar
signal health_depleted
@onready var level_lable: Label = %LevelLable

func _ready() -> void:
	xp_bar.max_value = experience_required
	xp_bar.value = experience
	update_level_display()
func update_level_display():
	level_lable.text = "Level:" + str(level)
func level_up():
	level += 1
	experience = 0
	experience_required += 1
	var tween = create_tween()
	level_lable.modulate = Color(2,2,2)
	tween.tween_property(level_lable , "modulate" ,Color(1,1,1),0.5)
	xp_bar.max_value = experience_required
	xp_bar.value = experience
	update_level_display()
	current_speed += speed_bost_amount
	var speed_tween = create_tween()
	speed_tween.tween_property(self , "scale" , Vector2(0.7 , 0.7) ,0.1)
	speed_tween.tween_property(self ,"scale" , Vector2(0.5, 0.5) ,0.1)
	print("NEW_SPEED" , current_speed)
	

func gain_experience(amount):
	experience += amount
	xp_bar.value = experience
	if experience >= experience_required:
		level_up()



var health = 100.0

func _physics_process(delta):
	var direction = Input.get_vector("left" , "right" , "up" , "down" )
	velocity = direction * current_speed
	move_and_slide()
	
	if velocity.length() > 0.0:
		get_node("MC").play_walk_animation()

	else:
		get_node("MC").play_idle_animation()
	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		
		if health <= 0.0:
			health_depleted.emit()
		


func _on_collection_range_area_entered(area: Area2D) -> void:
	if area.is_in_group("orbs"):
		area.start_magnet()
