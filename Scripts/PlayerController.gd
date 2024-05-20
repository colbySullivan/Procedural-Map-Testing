extends CharacterBody2D

@export var gravity = 400
@export var speed = 2
@export var jump_force = 200

@onready var animated_sprite = $AnimationPlayer
@onready var animated_tree = $AnimationTree

#func _process(delta):
	# animation handling
	#if Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left"):
		#animated_sprite.play("Walking")
	#else:
		#animated_sprite.play("Idle")

func _physics_process(delta):
	# gravity
	if is_on_floor() == false:
		velocity.y += gravity * delta
	
	# left and right movement
	#var direction = Input.get_axis("move_left","move_right")
	#velocity.x += direction * speed
	if Input.is_action_pressed("move_right"):
		velocity.x += 1.0
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1.0
		
	
	# jumping
	if Input.is_action_just_pressed("jump"):
		# TODO set up jump animation
		animated_tree.get("parameters/playback").travel("Jumping")
		velocity.y = -jump_force
		
	# handle animations
	if velocity.x == 0:
		animated_tree.get("parameters/playback").travel("idle")
	else:
		animated_tree.get("parameters/playback").travel("walking")
		animated_tree.set("parameters/idle/blend_position", velocity.x)
		animated_tree.set("parameters/walking/blend_position", velocity.x)
		
	move_and_slide()
	
