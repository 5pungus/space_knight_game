
```gdscript
extends CharacterBody2D

@export var speed : float = 80.0
@export var max_health : int = 80
@export var detection_radius : float = 400.0
@export var attack_radius : float = 300.0
@export var retreat_distance : float = 150.0
@export var patrol_radius : float = 150.0
@export var patrol_wait_time : float = 2.0
@export var knockback_resistance : float = 0.3

enum State { IDLE, PATROL, CHASE, ATTACK, RETREAT }
var current_state : State = State.IDLE

var player: CharacterBody2D
var last_known_player_position: Vector2
var patrol_target: Vector2
var patrol_wait_timer: float = 0.0

@onready var detection_area = $DetectionArea
@onready var weapon_node = $WeaponMount/weapon_template
@onready var animated_sprite = $AnimatedSprite2D

var health: float
@onready var health_bar = $EnemyHealthBar

var dead : bool = false

func _ready():
	player = get_node("/root/Main/Player")  # Adjust the path as needed
	setup_detection_area()
	randomize()
	set_new_patrol_target()
	
	detection_area.connect("body_entered", Callable(self, "_on_detection_area_body_entered"))
	detection_area.connect("body_exited", Callable(self, "_on_detection_area_body_exited"))
	
	# Initialize the weapon
	if weapon_node:
		weapon_node.initialize(self)
		
	#Initialize health and health bar. 
	health = max_health
	health_bar.initialize(health, max_health)
func _process(delta):
	if dead:
		return

	match current_state:
		State.IDLE:
			idle_behavior(delta)
		State.PATROL:
			patrol_behavior(delta)
		State.CHASE:
			chase_behavior(delta)
		State.ATTACK:
			attack_behavior(delta)
		State.RETREAT:
			retreat_behavior(delta)

	check_player_in_range()
	move_and_slide()
	update_animation()
	
func update_animation():
	if dead:
		animated_sprite.play("death")
	elif velocity.length() > 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	
	# Always face the player if they're in range, otherwise face the movement direction
	if is_instance_valid(player) and global_position.distance_to(player.global_position) <= detection_radius:
		var direction_to_player = player.global_position - global_position
		animated_sprite.flip_h = direction_to_player.x < 0
		if weapon_node:
			weapon_node.rotation = direction_to_player.angle()
		
func check_player_in_range():
	if is_instance_valid(player):
		var distance = global_position.distance_to(player.global_position)
		if distance <= detection_radius:
			if distance <= retreat_distance:
				current_state = State.RETREAT
			elif distance <= attack_radius:
				current_state = State.ATTACK
			else:
				current_state = State.CHASE

func chase_behavior(delta):
	if is_instance_valid(player):
		last_known_player_position = player.global_position
		var direction = (last_known_player_position - global_position).normalized()
		velocity = direction * speed

func get_target_position() -> Vector2:
	return player.global_position if is_instance_valid(player) else global_position

func attack_behavior(delta):
	if is_instance_valid(player):
		var direction = (player.global_position - global_position).normalized()
		velocity = Vector2.ZERO
		if weapon_node and weapon_node.has_method("fire"):
			weapon_node.fire()
	else:
		current_state = State.PATROL
func retreat_behavior(delta):
	if is_instance_valid(player):
		var direction = (global_position - player.global_position).normalized()
		velocity = direction * speed
		if weapon_node and weapon_node.has_method("fire"):
			weapon_node.fire()
	else:
		current_state = State.PATROL
		
func idle_behavior(delta):
	patrol_wait_timer += delta
	if patrol_wait_timer >= patrol_wait_time:
		set_new_patrol_target()
		current_state = State.PATROL

func patrol_behavior(delta):
	var direction = (patrol_target - global_position).normalized()
	velocity = direction * speed * 0.5

	if global_position.distance_to(patrol_target) < 5:
		current_state = State.IDLE
		patrol_wait_timer = 0

func set_new_patrol_target():
	var random_offset = Vector2(randf_range(-patrol_radius, patrol_radius), randf_range(-patrol_radius, patrol_radius))
	patrol_target = global_position + random_offset

func setup_detection_area():
	var shape = CircleShape2D.new()
	shape.radius = detection_radius
	detection_area.get_node("CollisionShape2D").shape = shape

func take_damage(dmg : int):
	if not dead:
		health -= dmg
		health_bar.update_health(health)
		print("Ranged enemy took", dmg, "damage. Health is now", health)
		if health <= 0:
			die()
		else:
			current_state = State.CHASE
			last_known_player_position = player.global_position if is_instance_valid(player) else global_position

func apply_knockback(force: Vector2):
	velocity += force * (1 - knockback_resistance)

func _on_detection_area_body_entered(body):
	if body.is_in_group("players"):
		current_state = State.CHASE

func _on_detection_area_body_exited(body):
	if body.is_in_group("players"):
		last_known_player_position = body.global_position

func die():
	dead = true
	print("Enemy killed")
	animated_sprite.play("death")
	# Wait for death animation to finish before removing the enemy
	await animated_sprite.animation_finished
	queue_free()

```