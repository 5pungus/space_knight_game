extends Node

func get_input_direction() -> Vector2:
    var input_direction = Vector2.ZERO
    input_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
    input_direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
    return input_direction.normalized()