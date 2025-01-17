extends StaticBody2D

var zone_number = 0 
var is_occupied = false
func _ready():
	var label_node = get_node("Label")
	if label_node and label_node is Label:
		label_node.modulate = Color(Color.WHITE)

			
