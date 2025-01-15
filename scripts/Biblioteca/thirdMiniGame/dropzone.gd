extends StaticBody2D

var zone_number = 0 
func _ready():
	modulate = Color(Color.MEDIUM_PURPLE, 0.7)
	var label_node = get_node("Label")
	if label_node and label_node is Label:
		label_node.modulate = Color(Color.WHITE)

			
