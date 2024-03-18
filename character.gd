extends CharacterBody2D

var mouse_input = Vector2()
var wasd_input = Vector2()

@export var colour = 1

@export var controlled_by_0 = true
@export var controlled_by_1 = false
@export var is_single_player = true
@export var is_keyboard = true

var jumped = false
var cayote = true

var jump_b
var shoot_b
var restore_b
var switch_b = "switch"
var left
var right
var look_left
var look_right
var look_up
var look_down

var bullet_impulse = 2000

var direction
var look_direction

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var gun = $gun
@onready var jump_timer = $"jump timer"

@onready var bullet_spawn = $"gun/bullet spawn"

@export var restore_scene = preload("res://white_restore.tscn")
@export var bullet_scene = preload("res://white_bullet.tscn")

var restore_pixels = []
var size_restore_step =  Vector2(0.01,0.01)

var min_size = Vector2(0.4,0.4)
var max_size =  Vector2(1.,1.)
var size_increment =  Vector2(0.12,0.12)
var target_size =  Vector2(1.,1.)

var tween : Tween

@onready var shoot_sound = $"shoot sound"
@onready var jump_sound = $"jump sound"
@onready var recall_sound = $"recall sound"
@onready var recall_pickup_sound = $"recall pickup sound"
@onready var switch_sound = $"switch sound"
@onready var animated_sprite_2d = $AnimatedSprite2D


func _ready():
	is_single_player = GameMaster.is_single_player
	is_keyboard = GameMaster.is_keyboard
	set_controls()

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if !is_on_floor() and jump_timer.is_stopped() and !jumped and cayote:
		cayote = false
		jump_timer.start()
	
	if is_on_floor():
		cayote = true
	
	if is_on_floor() and jumped:
		jumped = false
	
	# Handle Jump.
	if !(is_single_player and controlled_by_1) and Input.is_action_just_pressed(jump_b) and (is_on_floor() or !jump_timer.is_stopped()) and !jumped:
		velocity.y = JUMP_VELOCITY
		animated_sprite_2d.stop()
		animated_sprite_2d.play("Jump")
		jump_sound.play()
		jumped = true
		
	if Input.is_action_just_pressed(restore_b):
		restore()
	
	if Input.is_action_just_pressed(switch_b):
		switch()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	set_direction()
		
	velocity.x = direction * SPEED
	
	set_look_direction()
	
	if look_direction.length() >= 0.1:
		gun.look_at(gun.global_position + look_direction)
		if($gun/RayCast2D.is_colliding()):
			$gun/reticle.global_position = $gun/RayCast2D.get_collision_point()
		else:
			$gun/reticle.position = $gun/RayCast2D.target_position
	
	if Input.is_action_just_pressed(shoot_b):
		fire(gun.global_position + 600 * Vector2.from_angle(gun.rotation))
	
	if look_direction.x < 0:
		animated_sprite_2d.flip_h = true
	elif look_direction.x > 0:
		animated_sprite_2d.flip_h = false
	
	if direction != 0 and is_on_floor() and !jumped:
		animated_sprite_2d.play("Walk")
	elif is_on_floor()  and !jumped:
		animated_sprite_2d.play("Idle")
			
	if($gun/RayCast2D.is_colliding()):
		$gun/reticle.global_position = $gun/RayCast2D.get_collision_point()
	else:
		$gun/reticle.position = $gun/RayCast2D.target_position
	
	move_and_slide()
	
func _input(event):
	if event is InputEventMouseButton and controlled_by_0 and is_keyboard:
		if event.pressed:
			fire(event.position)
	elif event is InputEventMouseMotion and controlled_by_0 and is_keyboard:
		gun.look_at(event.position)
		if($gun/RayCast2D.is_colliding()):
			$gun/reticle.global_position = $gun/RayCast2D.get_collision_point()
		else:
			$gun/reticle.position = $gun/RayCast2D.target_position
		if event.position.x - global_position.x < 0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false

func fire(mouse_position):
	if is_single_player and controlled_by_1:
		return
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
	if is_single_player and controlled_by_1:
		return
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
	if is_single_player:
		controlled_by_0 = !controlled_by_0
		controlled_by_1 = !controlled_by_1
		set_controls()
		if controlled_by_0:
			switch_sound.play()

func tween_to_size(target_size : Vector2):
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", target_size, 1)

func set_controls():
	if is_single_player and controlled_by_1:
		gun.visible = false
	
	
	
	if is_single_player and controlled_by_0:
		gun.visible = true
		if is_keyboard:
			jump_b = "jump_k"
			shoot_b = "shoot_k"
			restore_b = "restore_k"
			left = "left_k"
			right = "right_k"
			look_left = null
			look_right = null
			look_up = null
			look_down = null
		else:
			jump_b = "jump_0"
			shoot_b = "shoot_0"
			restore_b = "restore_0"
			left = "left_0"
			right = "right_0"
			look_left = "look_left_0"
			look_right = "look_right_0"
			look_up = "look_up_0"
			look_down = "look_down_0"
	else:
		if controlled_by_0:
			if is_keyboard:
				jump_b = "jump_k"
				shoot_b = "shoot_k"
				restore_b = "restore_k"
				left = "left_k"
				right = "right_k"
				look_left = null
				look_right = null
				look_up = null
				look_down = null
			else:
				jump_b = "jump_0"
				shoot_b = "shoot_0"
				restore_b = "restore_0"
				left = "left_0"
				right = "right_0"
				look_left = "look_left_0"
				look_right = "look_right_0"
				look_up = "look_up_0"
				look_down = "look_down_0"
		else:
			if is_keyboard:
				jump_b = "jump_0"
				shoot_b = "shoot_0"
				restore_b = "restore_0"
				left = "left_0"
				right = "right_0"
				look_left = "look_left_0"
				look_right = "look_right_0"
				look_up = "look_up_0"
				look_down = "look_down_0"
			else:
				jump_b = "jump_1"
				shoot_b = "shoot_1"
				restore_b = "restore_1"
				left = "left_1"
				right = "right_1"
				look_left = "look_left_1"
				look_right = "look_right_1"
				look_up = "look_up_1"
				look_down = "look_down_1"

func set_direction():
	if is_single_player and controlled_by_1:
		direction = 0
	elif controlled_by_0 or controlled_by_1:
		direction = Input.get_axis(left, right)
	else:
		direction = 0

func set_look_direction():
	if is_single_player and controlled_by_1:
		look_direction = Vector2(0,0)
	elif (is_keyboard and controlled_by_1) or !is_keyboard:
		look_direction = Input.get_vector(look_left, look_right, look_up, look_down)
	else:
		look_direction = Vector2(0,0)
