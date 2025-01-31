extends Node2D

@onready var heartsContainer = $CanvasLayer/heartsContainer
@onready var player = $player
@onready var librerian: Sprite2D = $librerian
@onready var anim_scared: AnimationPlayer = $librerian/anim_scared

@onready var tilemap: TileMapLayer = $TileMap/TileMapLayer
@export var wall_mesh: PackedScene = preload("res://scenes/Biblioteca/firstMiniGame/probandomuros.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	introduce_dialogue()

func introduce_dialogue() -> void:
	#var used_cells = tilemap.get_used_cells()  # Obtener celdas usadas en la capa 0
	#for cell in used_cells:
		#var tile_position_2d  = tilemap.map_to_local(cell)
		#if tile_position_2d :  # Si hay un tile en esa celda
			#var wall = wall_mesh.instantiate()  # Instancia un muro 3D
			#add_child(wall)
			#wall.global_position = Vector3(tile_position_2d.x, 0, tile_position_2d.y)
			#wall.translate(Vector3(0, 0, 0))  # Ajustar altura
	librerian.visible = true
	player.can_move = false
	DialogueManager.show_example_dialogue_balloon(load("res://dialogues/b_minigame1.dialogue"), "start")

func on_maze_dialogue_finished() -> void:
	librerian.visible = false
	var player = get_tree().get_nodes_in_group("player")[0]  # 🔹 Encuentra al personaje (asegúrate de que está en el grupo "player")
	player.can_move = true  # 🔹 Ahora el jugador puede moverse
	heartsContainer.setMaxHearts(player.maxHealth)
	heartsContainer.updateHearts(player.currentHealth)
	player.healthChanged.connect(heartsContainer.updateHearts)

func _on_dialogue_step(tag: String) -> void:
	if tag == "scared":
		anim_scared.play("scared")  # Activa la animación
	elif tag == "normal":
		anim_scared.play("RESET")  # Regresa a la textura original
