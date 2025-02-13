extends Node2D

@onready var heartsContainer = $CanvasLayer/heartsContainer
@onready var player = $player
@onready var librerian: Sprite2D = $librerian
@onready var anim_scared: AnimationPlayer = $librerian/anim_scared
@onready var tilemap: TileMapLayer = $TileMap/TileMapLayer
@onready var timer: Control = $CanvasLayer/timer
signal can_move_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	introduce_dialogue()

func introduce_dialogue() -> void:
	librerian.visible = true
	player.can_move = false
	#timer.visible = false
	DialogueManager.show_example_dialogue_balloon(load("res://dialogues/b_minigame1.dialogue"), "start")

func on_maze_dialogue_finished() -> void:
	librerian.visible = false
	var player = get_tree().get_nodes_in_group("player")[0]  # 🔹 Encuentra al personaje (asegúrate de que está en el grupo "player")
	player.can_move = true  # 🔹 Ahora el jugador puede moverse
	#timer.visible = true
	emit_signal("can_move_changed")
	heartsContainer.setMaxHearts(player.maxHealth)
	heartsContainer.updateHearts(player.currentHealth)
	player.healthChanged.connect(heartsContainer.updateHearts)

func _on_dialogue_step(tag: String) -> void:
	if tag == "scared":
		anim_scared.play("scared")  # Activa la animación
	elif tag == "normal":
		anim_scared.play("RESET")  # Regresa a la textura original
