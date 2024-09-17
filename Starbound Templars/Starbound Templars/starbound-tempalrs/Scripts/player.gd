extends CharacterBody2D

# Player movement speed
@export var speed = 300
@export var smoothing: float = 0.05

# Function called every physics frame
func _physics_process(delta):
    
    #Call get_input() function
    get_input()

    # Move the character using move_and_slide()
    move_and_slide()

func get_input():
    # Get input direction
    var input_direction = Vector2.ZERO
    input_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
    input_direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
    
  

    # Normalize the input direction to prevent faster diagonal movement
    input_direction = input_direction.normalized()
    
    # Set velocity based on input direction and speed
    velocity = velocity.lerp(input_direction * speed, smoothing)