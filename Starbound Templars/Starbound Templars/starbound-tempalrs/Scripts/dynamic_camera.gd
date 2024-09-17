extends Camera2D


@export var target_distance = 0
@export var between_point = 0
@export var max_distance = 48
var center_pos = position


func _process(delta):
	var direction = center_pos.direction_to(get_local_mouse_position())
	var target_pos = center_pos + direction * target_distance

	position = target_pos

	target_pos = target_pos.clamp(
		center_pos - Vector2(max_distance, max_distance),
		center_pos + Vector2(max_distance, max_distance))
func _input(event):
	if event is InputEventMouseMotion:
		target_distance = center_pos.distance_to(get_local_mouse_position()) / between_point
