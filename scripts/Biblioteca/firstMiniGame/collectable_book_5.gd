extends "res://scripts/Biblioteca/firstMiniGame/collectable.gd"

@onready var animations = $AnimationPlayer
const booknumber = 98
func collect():
	animations.play("spin")
	await animations.animation_finished
	super.collect()
