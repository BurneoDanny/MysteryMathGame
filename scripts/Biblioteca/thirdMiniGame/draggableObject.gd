extends Node2D

signal placement_changed  
var draggable = false
var hovered_dropzone = false
var body_ref
var initialPos: Vector2
var pointer = load("res://assets/2dassets/kenney_cursor-pack/PNG/Basic/Default/hand_point.png")
var close = load("res://assets/2dassets/kenney_cursor-pack/PNG/Basic/Default/hand_closed.png")
var assigned_number = 0
static var is_dragging = null 
var placed_in_dropzone = false

func _process(delta: float) -> void:
	if placed_in_dropzone:
		return
	if draggable:
		if Input.is_action_just_pressed("click") and is_dragging == null:
			is_dragging = self
			initialPos = global_position
			z_index = 100
		if is_dragging == self and Input.is_action_pressed("click"):
			Input.set_custom_mouse_cursor(close, 0)
			global_position = get_global_mouse_position()
		elif is_dragging == self and Input.is_action_just_released("click"):
			Input.set_custom_mouse_cursor(pointer, 0)
			is_dragging = null
			z_index = 1
			var tween = get_tree().create_tween()
			print("hovered: ", hovered_dropzone)
			if body_ref:
				print("drop number: ", body_ref.get("zone_number"))
			else:
				print("body_ref es null")
			print("drag number: ", assigned_number)
			if hovered_dropzone and body_ref.get("zone_number") == assigned_number:
				tween.tween_property(self, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
				placed_in_dropzone = true
				body_ref.is_occupied = true
				body_ref.modulate = Color(Color.GREEN)
				emit_signal("placement_changed")
			else:
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_entered():
	if placed_in_dropzone:
		return
	if is_dragging == null:
		draggable = true
		scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited():
	if placed_in_dropzone:
		return
	draggable = false
	scale = Vector2(1, 1)

func _on_area_2d_body_entered(body: StaticBody2D):
	if body.is_in_group('dropzone') and not body.is_occupied:
		hovered_dropzone = true
		body.modulate = Color(Color.AQUA, 1)
		body_ref = body

func _on_area_2d_body_exited(body):
	if not body.is_occupied:
		body.modulate = Color(Color.WHITE)
		if body == body_ref:
			if body.is_in_group('dropzone') and not body.is_occupied:
				hovered_dropzone = false
				body_ref = null
