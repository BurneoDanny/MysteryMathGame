extends CharacterBody2D

const speed = 40

@export var player: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

func _ready() -> void:
	$AnimatedSprite2D.play("Ghost")
	makepath()

func _physics_process(_delta: float) -> void:
	if player.can_move:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed
		move_and_slide()
	
func makepath() -> void:
	if player.can_move: 
		nav_agent.target_position = player.global_position
	
func _on_timer_timeout():
	makepath()
