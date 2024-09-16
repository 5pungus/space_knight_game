extends Node2D

@export var number_of_projectiles: int = 1
@export var damage: float = 10.0
@export var projectile_speed: float = 1000.0
@export var spread: float = 0.0
@export var projectile_scene: PackedScene
@export var fire_rate: float = 0.2
@export var burst_fire_enabled: bool = false
@export var burst_count: int = 3
@export var burst_fire_rate: float = 0.05

@onready var fire_point = $FirePoint
@onready var fire_timer = $FireRateTimer
@onready var burst_timer = $BurstTimer
@onready var animated_sprite = $AnimatedSprite2D

var can_fire: bool = true
var owner_node : Node
var target_position: Vector2
var current_burst: int = 0
var is_bursting: bool = false
var fire_pressed: bool = false
var burst_direction: Vector2 = Vector2.ZERO

func _ready():
	fire_timer.wait_time = fire_rate
	fire_timer.one_shot = true
	burst_timer.wait_time = burst_fire_rate
	burst_timer.one_shot = true
	print("Weapon initialized with projectile speed:", projectile_speed)

	if not fire_timer.timeout.is_connected(Callable(self, "_on_fire_timer_timeout")):
		fire_timer.timeout.connect(_on_fire_timer_timeout)
	if not burst_timer.timeout.is_connected(Callable(self, "_on_burst_timer_timeout")):
		burst_timer.timeout.connect(_on_burst_timer_timeout)
	animated_sprite.play("idle")

func initialize(owner):
	owner_node = owner

func _process(delta):
	if owner_node is CharacterBody2D:
		if owner_node.is_in_group("players"):
			target_position = get_global_mouse_position()
		elif owner_node.has_method("get_target_position"):
			target_position = owner_node.get_target_position()
		
		if not is_bursting:
			update_weapon_rotation()
	
	if owner_node.is_in_group("players"):
		if Input.is_action_just_pressed("fire"):
			fire_pressed = true
		elif Input.is_action_just_released("fire"):
			fire_pressed = false
		
		if fire_pressed and can_fire and not is_bursting:
			fire()

func update_weapon_rotation():
	var direction = (target_position - global_position).normalized()
	var angle = direction.angle()
	
	# Rotate the weapon
	rotation = angle
	
	# Flip the sprite if aiming to the left, but keep the fire_point on the correct side
	if abs(angle) > PI/2:
		animated_sprite.flip_v = true
		fire_point.position.y = abs(fire_point.position.y)
	else:
		animated_sprite.flip_v = false
		fire_point.position.y = -abs(fire_point.position.y)

func fire():
	print("Fire method called. Burst fire enabled:", burst_fire_enabled)
	if can_fire:
		if burst_fire_enabled:
			start_burst()
		else:
			spawn_projectile()
			can_fire = false
			fire_timer.start(fire_rate)

func start_burst():
	print("Starting burst")
	current_burst = 0
	can_fire = false
	is_bursting = true
	burst_direction = (target_position - global_position).normalized()
	_continue_burst()

func _continue_burst():
	if current_burst < burst_count:
		print("Continuing burst, bullet", current_burst + 1, "of", burst_count)
		spawn_projectile()
		current_burst += 1
		burst_timer.start(burst_fire_rate)
	else:
		print("Burst complete")
		is_bursting = false
		fire_timer.start(fire_rate)

func spawn_projectile():
	var spawn_position = fire_point.global_position
	var direction = burst_direction if is_bursting else (target_position - spawn_position).normalized()
	
	print("Spawning projectile from position:", spawn_position)
	for i in range(number_of_projectiles):
		var projectile = projectile_scene.instantiate()
		var angle = randf_range(-spread / 2, spread / 2)
		var spread_direction = direction.rotated(angle)
		var projectile_rotation = spread_direction.angle()
		
		projectile.rotation = projectile_rotation
		projectile.initialize(spawn_position, damage, projectile_speed, owner_node, spread_direction)
		get_tree().root.add_child(projectile)
		print("Projectile spawned with damage:", damage)
		print("Projectile spawned with speed:", projectile_speed)
	animated_sprite.play("firing")

func _on_fire_timer_timeout():
	print("Fire timer timeout")
	can_fire = true	

func _on_burst_timer_timeout():
	print("Burst timer timeout")
	_continue_burst()
	
func reset_fire_state():
	can_fire = true
	is_bursting = false
	fire_pressed = false
	fire_timer.stop()
	burst_timer.stop()
	current_burst = 0
	burst_direction = Vector2.ZERO
	print("Fire state manually reset. Can fire:", can_fire)