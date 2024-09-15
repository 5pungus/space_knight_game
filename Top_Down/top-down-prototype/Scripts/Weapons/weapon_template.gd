extends Node2D


@export var number_of_projectiles: int = 1
@export var damage: float = 10.0
@export var projectile_speed: float = 1000.0
@export var spread: float = 0.0
@export var projectile_scene: PackedScene
@export var fire_rate: float = 0.2
@onready var fire_point = $FirePoint
@onready var fire_timer = $FireRateTimer
@onready var animated_sprite = $AnimatedSprite2D


var can_fire: bool = true
var owner_node : Node
var target_position: Vector2

func _ready():
	
	fire_timer.wait_time = fire_rate
	fire_timer.one_shot = true
	print ("Weapon initialized with projectile speed:", projectile_speed)

	if not fire_timer.timeout.is_connected(Callable(self, "_on_fire_timer_timeout")):
		fire_timer.timeout.connect(_on_fire_timer_timeout)
	animated_sprite.play("idle")

func initialize(owner):
	owner_node = owner

func _process(delta):
	if owner_node is CharacterBody2D:
		if owner_node.is_in_group("players"):
			target_position = get_global_mouse_position()
		elif owner_node.has_method("get_target_position"):
			target_position = owner_node.get_target_position()
		look_at(target_position)
	if owner_node.is_in_group("players") and Input.is_action_pressed("fire") and can_fire:
		fire()

func fire():
	if can_fire:
		spawn_projectile()
		can_fire = false
		$FireRateTimer.start(fire_rate)

#Handles Projectile Initiation
func spawn_projectile():
	for i in range(number_of_projectiles):
		#Establish Bullet Launch Variables
		#Instantiate projectile scene
		var projectile = projectile_scene.instantiate()
		#Get the mouse position and assign it to the 'mouse_position' variable
		var direction = (target_position - fire_point.global_position).normalized()

		#set bullet spread to the angle variable
		var angle = randf_range(-spread / 2, spread / 2)
		var spread_direction = direction.rotated(angle)
		
		#assign the projectile rotation to the projectile_rotation variable
		var projectile_rotation = spread_direction.angle()
		
	
		#set angle of bullet to point at mouse position. 
		projectile.rotation = projectile_rotation
		
		
		#launch bullet at mouse position. 
		projectile.initialize(fire_point.global_position, damage, projectile_speed, owner_node, spread_direction,)
		get_tree().root.add_child(projectile)
		print ("Projectile spawned with damage:", damage )
		print ("Projectile spawned with speed:", projectile_speed )
		animated_sprite.play("firing")
		#await animated_sprite.animation_finished
		#animated_sprite.play("idle")

		
func _on_fire_timer_timeout():
	can_fire = true	
	
func reset_fire_state():
	can_fire = true
	fire_timer.stop()
	print("Fire state manually reset. Can fire:", can_fire)

