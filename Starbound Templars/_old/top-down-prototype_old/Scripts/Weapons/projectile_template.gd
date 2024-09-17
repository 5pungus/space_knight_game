extends Area2D

var speed: float
var damage: float
var shooter = Node
var spread_direction: Vector2

#Manage projectile lifetime
@export var time_limit: float = 1
@export var time_elapsed : float = 0.0

#Projectile variables
@export var glow_effect : PackedScene
@export var trail_effect : PackedScene

var trail_instance: GPUParticles2D


@onready var collision_shape = $CollisionShape2D
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	animated_sprite.play("flying")

func initialize(pos: Vector2, dmg : float, spd: float, owner: Node, sprd: Vector2):
	global_position = pos
	speed = spd
	shooter = owner
	damage = dmg
	spread_direction = sprd
	
	if glow_effect:
		var glow = glow_effect.instantiate()
		add_child(glow)
	
	if trail_effect and is_inside_tree():
		trail_instance = trail_effect.instantiate()
		get_parent().add_child(trail_instance)
		trail_instance.global_position = global_position
		
func _process(delta):
	global_position += spread_direction * speed * delta
	
	time_elapsed += delta # Increment elapsed time
	if time_elapsed > time_limit:
		destroy()
	if trail_instance:
		trail_instance.global_position = global_position
		
func _on_body_entered(body):
	if body != shooter and body.has_method("take_damage"):
		body.take_damage(damage)
		if trail_instance:
			trail_instance.start_fading()
		destroy()
	else:
		destroy()

func _on_screen_exited():
	destroy()
	
func destroy():
	speed = 0
	spread_direction = Vector2.ZERO
	
	if trail_instance:
		trail_instance.start_fading()
		animated_sprite.play("impact")
		await animated_sprite.animation_finished
		animated_sprite.play("dead")
		
		queue_free()
	else:
		animated_sprite.play("impact")
		await animated_sprite.animation_finished
		animated_sprite.play("dead")
		queue_free()
