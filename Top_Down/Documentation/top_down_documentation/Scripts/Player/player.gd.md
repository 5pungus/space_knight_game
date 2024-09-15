
```gdscript
extends CharacterBody2D


@export var health : int = 100
@export var player_speed = 500

#Export health regen variables
@export var health_regen_rate : float = 0.1
@export var health_regen_delay : float = 5.0
var time_since_last_damage : float = 0.0

@export var ability_1_scene : PackedScene
@export var ability_2_scene : PackedScene
@export var ability_3_scene : PackedScene
@export var super_ability_scene : PackedScene

#nodes
@onready var weapon_node = $WeaponMount/weapon_template
@onready var animated_sprite = $AnimatedSprite2D
@onready var hud = $CanvasLayer/HUD
@onready var heal_time = $HealTimer
@onready var ability_1_node : Node
@onready var ability_2_node : Node
@onready var ability_3_node : Node
@onready var super_ability_node : Node

#Weapon Slot Variables. 
@export var weapon_1_scene : PackedScene
@export var weapon_2_scene : PackedScene
@export var weapon_3_scene : PackedScene

var screen_size: Vector2
var dead : bool = false


func _ready():
	add_to_group("players")
	screen_size = get_viewport_rect().size
	print("Player position: ", global_position)
	animated_sprite.play("idle")	
	
	
	# Initialize the weapon node
	if weapon_node:
		weapon_node.initialize(self)
	
	#Initialize HUD
	hud.update_health(health)
	hud.set_bar_max(health)
	
	#initialize abilities
	initialize_abilities()
	
func initialize_abilities():
	ability_1_node = instantiate_ability(ability_1_scene)
	ability_2_node = instantiate_ability(ability_2_scene)
	ability_3_node = instantiate_ability(ability_3_scene)
	super_ability_node = instantiate_ability(super_ability_scene)
	
func instantiate_ability(ability_scene: PackedScene) -> Node:
	if ability_scene:
		var ability = ability_scene.instantiate()
		add_child(ability)
		if ability.has_method("initialize"):
			ability.initialize(self)
		return ability
	return null
	
func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir.normalized() * player_speed
	if velocity.length() > 0:
		animated_sprite.play("run")
	else:
		if animated_sprite.animation == "run":
			animated_sprite.play("idle")
	
	if Input.is_action_just_pressed("weapon1"):
		var weapon_1: int = 1
		switch_weapon(weapon_1_scene)
		hud.weapon_highlight(weapon_1)
	elif Input.is_action_just_pressed("weapon2"):
		var weapon_2: int = 2
		switch_weapon(weapon_2_scene)
		hud.weapon_highlight(weapon_2)
	elif Input.is_action_just_pressed("weapon3"):
		var weapon_3: int = 3
		switch_weapon(weapon_3_scene)
		hud.weapon_highlight(weapon_3)

	face_mouse()
	 # Ability input handling
	if Input.is_action_just_pressed("ability1"):
		use_ability(ability_1_node)
	elif Input.is_action_just_pressed("ability2"):
		use_ability(ability_2_node)
	elif Input.is_action_just_pressed("ability3"):
		use_ability(ability_3_node)
	elif Input.is_action_just_pressed("super_ability"):
		use_ability(super_ability_node)

func use_ability(ability_node: Node):
	# Function to trigger an ability if it exists and is ready
	if ability_node and ability_node.has_method("use"):
		ability_node.use()
		
func face_mouse():
	var mouse_pos = get_global_mouse_position()
	var angle_to_mouse = global_position.angle_to_point(mouse_pos)
	
	if abs(angle_to_mouse) < PI/2:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true

func _physics_process(delta):
	get_input()
	move_and_slide()
	handle_weapon_aiming()
	handle_health_regeneration(delta)
	
func handle_weapon_aiming():
	# Handle weapon aiming and firing
	if weapon_node:
		var mouse_pos = get_global_mouse_position()
		var angle_to_mouse = global_position.angle_to_point(mouse_pos)
		#weapon_node.look_at(mouse_pos)
		
		if abs(angle_to_mouse) < PI/2:
			weapon_node.scale.y = 1
		else:
			weapon_node.scale.y = -1
			
		weapon_node.rotation = angle_to_mouse - PI/2 if weapon_node.scale.y > 0 else angle_to_mouse + PI/2
			
		if Input.is_action_pressed("fire"):
			if weapon_node.has_method("fire"):
				weapon_node.fire()
			elif weapon_node.has_method("attack"):
				weapon_node.attack()	

func handle_health_regeneration(delta):
		 # Increment the time since last damage
	time_since_last_damage += delta
	
	# Check if enough time has passed to start regenerating health
	if time_since_last_damage >= health_regen_delay:
		var regen_amount = health * health_regen_rate * delta
		health = min(health + regen_amount, 100)  # Assuming max health is 100
		hud.update_health(health)
		
func switch_weapon(new_weapon_scene: PackedScene):
	if not new_weapon_scene:
		print("Weapon scene not assigned!")
		return
	
	if weapon_node:
		weapon_node.queue_free()

	
	var new_weapon = new_weapon_scene.instantiate()
	add_child(new_weapon)
	weapon_node = new_weapon
	if weapon_node.has_method("initialize"):
		weapon_node.initialize(self)

# Function to handle getting hit by projectiles
func take_damage(damage : int):
	# Implement damage logic here
	if not dead:
		health -= damage
		print("Player took ", damage, " damage! Health:", health)
		hud.update_health(health) #Update HUD
		if health <= 0:
			die()

func die():
	dead = true
	print("You Died!")
	await get_tree().create_timer(1.0).timeout
	animated_sprite.play("death")
	restart_level()

func restart_level():
	reset_player()

 # Respawn enemies (you'll need to implement this in your main scene)
  
	
	# Reset any other level-specific elements
	# For example, resetting collectibles, traps, etc.
  
	
	print("Level restarted")

func reset_player():
	dead = false
	health = 100
	position = Vector2(100,100)
	hud.update_health(health)
	animated_sprite.play("idle")

func apply_knockback(force: Vector2):
		velocity += force
		move_and_slide()

func _unhandled_input(event):
	pass
	


```