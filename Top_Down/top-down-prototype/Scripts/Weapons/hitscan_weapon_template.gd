extends Node2D

@export var damage: float = 20.0
@export var max_distance: float = 1000.0
@export var fire_rate: float = 0.2
@export var weapon_texture: Texture2D

@onready var sprite = $Sprite2D
@onready var fire_point = $FirePoint
@onready var fire_timer = $FireRateTimer
@onready var ray_cast = $RayCast2D
@onready var line_2d = $Line2D

var can_fire: bool = true
var owner_node: Node

func _ready():
	sprite.texture = weapon_texture
	fire_timer.wait_time = fire_rate
	fire_timer.one_shot = true
	
	ray_cast.target_position = Vector2(max_distance, 0)
	ray_cast.collision_mask = 3  # Adjust this based on your collision layers
	
	line_2d.default_color = Color.RED
	line_2d.width = 2.0
	line_2d.clear_points()
	
	if not fire_timer.timeout.is_connected(Callable(self, "_on_fire_timer_timeout")):
		fire_timer.timeout.connect(_on_fire_timer_timeout)

func initialize(owner):
	owner_node = owner

func _process(delta):
	if owner_node is CharacterBody2D:
		if owner_node.is_in_group("players"):
			look_at(get_global_mouse_position())
		else:
			look_at(owner_node.player.global_position)
	
	if Input.is_action_pressed("fire") and can_fire:
		fire()

func fire():
	if can_fire:
		perform_raycast()
		can_fire = false
		fire_timer.start(fire_rate)

func perform_raycast():
	ray_cast.force_raycast_update()
	
	var end_point = ray_cast.target_position
	if ray_cast.is_colliding():
		end_point = ray_cast.get_collision_point() - global_position
		var collider = ray_cast.get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage(damage)
			print("Hit ", collider.name, "for ", damage, " damage")
	
	draw_shot_line(end_point)

func draw_shot_line(end_point: Vector2):
	line_2d.clear_points()
	line_2d.add_point(Vector2.ZERO)
	line_2d.add_point(end_point)
	
	# Fade out the line
	var tween = create_tween()
	tween.tween_property(line_2d, "modulate:a", 0.0, 0.1)
	tween.tween_callback(line_2d.clear_points)

func _on_fire_timer_timeout():
	can_fire = true

func reset_fire_state():
	can_fire = true
	fire_timer.stop()
	print("Fire state manually reset. Can fire:", can_fire)
