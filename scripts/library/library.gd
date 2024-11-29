extends Node2D

var book = preload('res://scenes/library/thirdMiniGame/draggableObject.tscn')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instBook(Vector2(0,0))
	instBook(Vector2(0,100))

func instBook(pos) -> void:
	var instance = book.instantiate()
	instance.position = pos
	add_child(instance)
