extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var gun = $gun
const bullet = preload("res://black_bullet.tscn")
@onready var bullet_spawn = $"gun/bullet spawn"
const BLACK_RESTORE = preload("res://black_restore.tscn")
var blackened_pixels = []

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump_1") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
	if Input.is_action_just_pressed("restore_1"):
		restore()

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
	
func add_blackened_pixel(pixel):
	if pixel not in blackened_pixels:
		blackened_pixels.append(pixel)
		
func restore():
	for pix in blackened_pixels:
		if pix.get_meta("colour", 0) == 1:
			pix.visible = true
			pix.set_collision_layer_value(1, true)
			pix.set_collision_layer_value(2, false)
			var new_restore = BLACK_RESTORE.instantiate()
			add_sibling(new_restore)
			new_restore.position = pix.position
			new_restore.scale *= randf_range(0.2, 1.)
	blackened_pixels = []


func on_restore_pickup():
	pass
