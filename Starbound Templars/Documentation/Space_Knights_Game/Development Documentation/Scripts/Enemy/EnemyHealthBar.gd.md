```gdscript
extends Control

@export var min_width: float = 50.0
@export var max_width: float = 100.0

@onready var progress_bar = $ProgressBar

var max_health: float = 100.0

func initialize(initial_health: float, max_health: float):
	self.max_health = max_health
	progress_bar.max_value = max_health
	update_health(initial_health)

func update_health(current_health: float):
	progress_bar.value = current_health
	var health_ratio = current_health / max_health
	var new_width = lerp(min_width, max_width, health_ratio)
	progress_bar.size.x = new_width
	progress_bar.position.x = -new_width / 2

```