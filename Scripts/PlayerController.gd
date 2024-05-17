extends CharacterBody2D

@export var gravity = 400
@export var speed = 2
@export var jump_force = 200

@onready var animated_sprite = $AnimationPlayer

func _process(delta):
	# animation handling
	if Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left"):
		animated_sprite.play("Walking")
	else:
		animated_sprite.play("Idle")

func _physics_process(delta):
	# gravity
	if is_on_floor() == false:
		velocity.y += gravity * delta
	
	# left and right movement
	var direction = Input.get_axis("move_left","move_right")
	velocity.x += direction * speed
	
	# jumping
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force
	move_and_slide()
	
