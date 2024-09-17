extends Node2D

@export var damage: int = 20
@export var attack_speed: float = 1.0  # Attacks per second
@export var attack_range: float = 100.0
@export var knockback_force: float = 100.0
@export var attack_angle: float = 60.0  # in degrees

var can_attack: bool = true
var player: CharacterBody2D

@onready var attack_timer = $AttackTimer
@onready var attack_area = $AttackArea
@onready var attack_collision = $AttackArea/CollisionShape2D

func _ready():
	attack_timer.wait_time = 1.0 / attack_speed
	attack_area.monitoring = false
	setup_attack_area()

func initialize(parent_player):
	player = parent_player

func setup_attack_area():
	var shape = CircleShape2D.new()
	shape.radius = attack_range
	attack_collision.shape = shape

func _process(delta):
	if player:
		look_at(get_global_mouse_position())

func attack():
	if can_attack:
		perform_attack()
		can_attack = false
		attack_timer.start()

func perform_attack():
	attack_area.monitoring = true
	
	# Create an animation for the attack (you can replace this with a proper AnimationPlayer if desired)
	var tween = create_tween()
	tween.tween_property(self, "rotation", rotation + deg_to_rad(attack_angle), 0.1)
	tween.tween_property(self, "rotation", rotation, 0.1)
	
	await get_tree().create_timer(0.2).timeout
	attack_area.monitoring = false

func _on_attack_timer_timeout():
	can_attack = true

func _on_attack_area_body_entered(body):
	if body.has_method("take_damage") and body != player:
		body.take_damage(damage)
		
		# Apply knockback
		var knockback_direction = (body.global_position - global_position).normalized()
		if body.has_method("apply_knockback"):
			body.apply_knockback(knockback_direction * knockback_force)
