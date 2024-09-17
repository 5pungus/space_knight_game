extends Node2D

class_name DashAbility

# Ability parameters
@export var dash_distance: float = 200.0
@export var dash_duration: float = 0.2
@export var cooldown_time: float = 3.0


# Internal variables
var player: CharacterBody2D
var is_ready: bool = true
var cooldown_timer: Timer

func _ready():
	# Set up the cooldown timer
	cooldown_timer = Timer.new()
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.connect("timeout", Callable(self, "_on_cooldown_timer_timeout"))
	add_child(cooldown_timer)

func initialize(player_node: CharacterBody2D):
	# Called by the player to set up the ability
	player = player_node

func use():
	if is_ready and player:
		perform_dash()
		start_cooldown()

func perform_dash():
	# Ensure velocity is not zero before normalizing
	var dash_vector = Vector2.ZERO
	if player.velocity != Vector2.ZERO:
		dash_vector = player.velocity.normalized() * dash_distance
	else:
		dash_vector = Vector2.RIGHT.rotated(player.rotation) * dash_distance
	# Create a tween for smooth movement
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	# Perform the dash
	tween.tween_property(player, "global_position", player.global_position + dash_vector, dash_duration)
	
	# Optional: Play a dash effect or sound
	play_dash_effect()

func play_dash_effect():
	# Implement visual or audio effects for the dash
	# For example, you could instantiate a particle system or play a sound
	print("Dash effect played")

func start_cooldown():
	is_ready = false
	cooldown_timer.start()

func _on_cooldown_timer_timeout():
	is_ready = true
	print("Dash ability ready")

# Optional: Add a method to check if the ability is ready
func is_ability_ready() -> bool:
	return is_ready
