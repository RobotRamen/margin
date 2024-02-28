extends Marker2D

@export var scene : PackedScene = null
var clear

func _ready():
	clear = get_node("../black_start")
	clear.cleared.connect(spawn)

func spawn():
	var instant = scene.instantiate()
	add_sibling(instant)
	instant.position = position
	queue_free()
