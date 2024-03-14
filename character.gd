extends CharacterBody2D

var mouse_input = Vector2()
var wasd_input = Vector2()

@export var colour = 1

@export var controlled_by_0 = true
@export var controlled_by_1 = false
var jump_b = "jump_0"
var shoot_b = "shoot_0"
var restore_b = "restore_0"
var switch_b = "switch"

var bullet_impulse = 2000

var direction
var look_direction

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var gun = $gun

@onready var bullet_spawn = $"gun/bullet spawn"

@export var restore_scene = preload("res://white_restore.tscn")
@export var bullet_scene = preload("res://white_bullet.tscn")

var restore_pixels = []
var size_restore_step =  Vector2(0.01,0.01)

var min_size = Vector2(0.4,0.4)
var max_size =  Vector2(1.,1.)
var size_increment =  Vector2(0.2,0.2)
var target_size =  Vector2(1.,1.)

var tween : Tween

@onready var shoot_sound = $"shoot sound"
@onready var jump_sound = $"jump sound"
@onready var recall_sound = $"recall sound"
@onready var recall_pickup_sound = $"recall pickup sound"
@onready var switch_sound = $"switch sound"
@onready var animated_sprite_2d = $AnimatedSprite2D


func _ready():
	if controlled_by_0:
		jump_b = "jump_0"
		shoot_b = "shoot_0"
		restore_b = "restore_0"
	if controlled_by_1:
		jump_b = "jump_1"
		shoot_b = "shoot_1"
		restore_b = "restore_1"
		

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#if is_on_floor() and animated_sprite_2d.animation == "Jump":
		#animated_sprite_2d.play("Idle")
	

	# Handle Jump.
	if Input.is_action_just_pressed(jump_b) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed(restore_b):
		restore()
	
	if Input.is_action_just_pressed(switch_b):
		switch()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if controlled_by_0:
		direction = Input.get_axis("left_0", "right_0")
	elif controlled_by_1:
		direction = Input.get_axis("left_1", "right_1")
	else:
		direction = 0
		
	velocity.x = direction * SPEED
	
	if controlled_by_0:
		look_direction = Input.get_vector("look_left_0", "look_right_0", "look_up_0", "look_down_0")
	elif controlled_by_1:
		look_direction = Input.get_vector("look_left_1", "look_right_1", "look_up_1", "look_down_1")
	else:
		look_direction = Vector2(0,0)
	
	if look_direction.length() >= 0.1:
		gun.look_at(gun.global_position + look_direction)
	
	if Input.is_action_just_pressed(shoot_b):
		fire(gun.global_position + 600 * Vector2.from_angle(gun.rotation))
	
	print(look_direction)
	
	if look_direction.x < 0:
		animated_sprite_2d.flip_h = true
	elif look_direction.x > 0:
		animated_sprite_2d.flip_h = false
	
	if direction != 0:
		animated_sprite_2d.play("Walk")
	else:
		animated_sprite_2d.play("Idle")
	
	move_and_slide()
	
func _input(event):
	if event is InputEventMouseButton and controlled_by_0:
		if event.pressed:
			fire(event.position)
	elif event is InputEventMouseMotion and controlled_by_0:
		gun.look_at(event.position)
		if event.position.x - global_position.x < 0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false

func fire(mouse_position):
	if scale - (size_increment/2)  <= min_size:
		scale = min_size
	else:
		#scale = (scale-size_increment).clamp(min_size, max_size)
		tween_to_size((scale-size_increment).clamp(min_size, max_size))
		var new_bullet : RigidBody2D = bullet_scene.instantiate()
		add_sibling(new_bullet)
		new_bullet.position = bullet_spawn.global_position
		new_bullet.apply_central_impulse((mouse_position - new_bullet.position).normalized() * bullet_impulse)
		shoot_sound.play()

func add_pixel(pixel):
	if pixel not in restore_pixels:
		restore_pixels.append(pixel)
		
func restore():
	var restores = 0
	if colour == 1:
		for pix in restore_pixels:
			if pix.get_meta("colour", 0) == 2:
				restores += 1
				pix.get_node("main_sprite").visible = false
				pix.get_node("side_sprites").modulate = Color(0,0,0,1)
				pix.set_collision_layer_value(2, true)
				pix.set_collision_layer_value(1, false)
				var new_restore = restore_scene.instantiate()
				add_sibling(new_restore)
				new_restore.position = pix.position
				new_restore.scale *= randf_range(0.2, 1.)
				
				
	elif colour == 2:
		for pix in restore_pixels:
			if pix.get_meta("colour", 0) == 1:
				restores += 1
				pix.get_node("main_sprite").visible = true
				pix.get_node("side_sprites").modulate = Color(1,1,1,1)
				pix.set_collision_layer_value(1, true)
				pix.set_collision_layer_value(2, false)
				var new_restore = restore_scene.instantiate()
				add_sibling(new_restore)
				new_restore.position = pix.position
				new_restore.scale *= randf_range(0.2, 1.)
		
	if(restores):
		size_restore_step = (max_size - scale)/restores
		recall_sound.play()
		target_size = scale
	else:
		size_restore_step = max_size - scale
		scale = max_size
	restore_pixels = []

func on_restore_pickup():
	recall_pickup_sound.play()
	if scale >= max_size:
		scale.clamp(min_size, max_size)
	else:
		#scale += size_restore_step
		target_size += size_restore_step
		tween_to_size((target_size).clamp(min_size, max_size))
		scale.clamp(min_size, max_size)
		

func switch():
	controlled_by_0 = !controlled_by_0
	controlled_by_1 = !controlled_by_1
	if controlled_by_0:
		jump_b = "jump_0"
		shoot_b = "shoot_0"
		restore_b = "restore_0"
		switch_sound.play()
	else:
		jump_b = "jump_1"
		shoot_b = "shoot_1"
		restore_b = "restore_1"

func tween_to_size(target_size : Vector2):
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", target_size, 1)
