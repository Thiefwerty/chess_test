extends Node2D

var array = [Vector2(0.0, -1.0)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Vector2i(0.0, -1.0) in array:
		print("Yes")
