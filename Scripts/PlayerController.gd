extends CharacterBody2D

@export var gravity = 400
@export var speed = 5
@export var jump_force = 200

@onready var animated_sprite = $AnimationPlayer
@onready var animated_tree = $AnimationTree

var can_jump = true
# use this for dashing
var moving = false

@export var ghost_node : PackedScene
@onready var ghost_timer = $GhostTimer
#func _process(delta):
	# animation handling
	#if Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left"):
		#animated_sprite.play("Walking")
	#else:
		#animated_sprite.play("Idle")

func _physics_process(delta):
	# gravity and floor check
	if is_on_floor() == false:
		velocity.y += gravity * delta
		can_jump = false
	
	else:
		can_jump = true
		
	horizontal_movement()
	
	# jumping
	if Input.is_action_just_pressed("jump") && can_jump:
		# TODO set up jump animation
		animated_tree.get("parameters/playback").travel("Jumping")
		velocity.y = -jump_force
	
	check_animation_orientation()
	fall_check()
	move_and_slide()

func horizontal_movement():
	# left and right movement
	if Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left"):
		var direction = Input.get_axis("move_left","move_right")
		velocity.x += direction * speed
		moving = true
	elif is_on_floor() == true:
		# TODO there is a case where this step is missed due to the user holding the opposite direction
		# therefore I need to rewrite the friction method
		moving = false
		velocity.x = lerp(velocity.x, 0.0, 1)

func fall_check():
	if position.y > 100:
		get_tree().reload_current_scene()

# handle animations
func check_animation_orientation():
	if velocity.x == 0.0:
		animated_tree.get("parameters/playback").travel("idle")
	else:
		animated_tree.get("parameters/playback").travel("walking")
		animated_tree.set("parameters/idle/blend_position", velocity.x)
		animated_tree.set("parameters/walking/blend_position", velocity.x)

# TODO need a better way of doing
# Also there is a snapping back issue when user releases in the air
func check_ghosting_orientation(ghost):
	if velocity.x > 0:
		ghost.flip_h = false
	elif velocity.x < 0:
		ghost.flip_h = true
		
func add_ghost():
	var ghost = ghost_node.instantiate()
	# need to offset y due to scene pos issues
	ghost.position = position + Vector2(0,-6)
	check_ghosting_orientation(ghost)
	get_tree().current_scene.add_child(ghost)
	#pass


func _on_ghost_timer_timeout():
	if moving == true:
		add_ghost()
