extends RigidBody2D

@onready var blob = preload("res://white_blobber.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if get_contact_count():
		var new_blob = blob.instantiate()
		add_sibling(new_blob)
		new_blob.position = position
		queue_free()
