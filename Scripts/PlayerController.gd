extends CharacterBody2D

@export var gravity = 400
@export var speed = 5

@onready var animated_sprite = $AnimationPlayer
@onready var animated_tree = $AnimationTree

# use this for dashing and ghosting effect
var moving = false
var going_ghost = false

@export var ghost_node : PackedScene
@onready var ghost_timer = $GhostTimer
#func _process(delta):
	# animation handling
	#if Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left"):
		#animated_sprite.play("Walking")
	#else:
		#animated_sprite.play("Idle")

func _physics_process(delta):
	if Input.is_action_pressed("dash"):
		going_ghost = true
	else:
		going_ghost = false
	horizontal_movement()
	
	check_animation_orientation()
	fall_check()
	move_and_slide()

func horizontal_movement():
	# left and right movement
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity += direction * speed
	if velocity:
		moving = true
	else:
		moving = false

func fall_check():
	if position.y > 2000:
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
	if moving && going_ghost:
		add_ghost()
