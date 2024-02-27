extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var gun = $gun
@onready var bullet = preload("res://white_bullet.tscn")
@onready var bullet_spawn = $"gun/bullet spawn"


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump_1") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left_1", "right_1")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			fire(event.position)
	elif event is InputEventMouseMotion:
		gun.look_at(event.position)

func fire(mouse_position):
	var new_bullet : RigidBody2D = bullet.instantiate()
	add_sibling(new_bullet)
	new_bullet.position = bullet_spawn.global_position
	new_bullet.apply_central_impulse((mouse_position - new_bullet.position).normalized() * 1000.0)
