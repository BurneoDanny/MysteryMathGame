extends CharacterBody2D

const speed = 100
var current_dir = "none"
@onready var effects = $Effects
@onready var hurtTimer = $hurtTimer
@export var knockbackPower: int = 500
@export var maxHealth = 3
@onready var currentHealth: int = maxHealth
@onready var hurtBox = $hurtbox
signal healthChanged
var isHurt: bool = false
var can_move = false  # 🔹 Controla si el jugador puede moverse

func _ready():
	$AnimatedSprite2D.play("front_idle")
	effects.play("RESET")
	
func handle_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		print_debug(collider.name)

func _physics_process(delta):
	player_movement(delta)
	handle_collision()
	if !isHurt:
		for area in hurtBox.get_overlapping_areas():
			if area.name == "hitbox":
				hurtByEnemy(area)
			
func hurtByEnemy(area):
	currentHealth -= 1
	if currentHealth == 0:
		currentHealth = maxHealth
		_on_health_equal_zero()
	healthChanged.emit(currentHealth)
	isHurt = true
	knockback(area.get_parent().velocity)
	effects.play("hurtBlink")
	hurtTimer.start()
	await hurtTimer.timeout
	effects.play("RESET")
	isHurt = false

func player_movement(delta):
	if not can_move:  # 🔹 Bloquea el movimiento al inicio
		velocity = Vector2.ZERO
		return
		
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0

	move_and_slide()


func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D

	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")

	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")

	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")

	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")


func _on_hurtbox_area_entered(area):
	if area.has_method("collect"):
		area.collect()

	
func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	print_debug(velocity)
	print_debug(position)
	move_and_slide()
	print_debug(position)
	print_debug(" ")
	print_debug("current HEALTH = ",currentHealth)
	
	
func _on_health_equal_zero():
		get_tree().change_scene_to_file("res://scenes/gameover.tscn")
