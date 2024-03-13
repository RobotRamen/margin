extends Area2D
@onready var sprite_2d = $Sprite2D
@onready var black_character = $"../blackCharacter"
const final_speed = 1000
var speed = 1
var direction
func _ready():
	var initial_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	direction = initial_direction
	sprite_2d.rotation = randf_range(0, 10)

func _physics_process(delta):
	var direction_to_character : Vector2 = (black_character.position + Vector2(0,-50)*black_character.scale.x) - position
	direction_to_character = direction_to_character.normalized()
	direction = ((direction_to_character + direction*3)/4).normalized()
	speed = (speed*4 + final_speed)/5
	position += direction * delta * speed
	sprite_2d.rotation = randf_range(0, 10)
	
	if get_overlapping_bodies():
		black_character.on_restore_pickup()
		queue_free()
