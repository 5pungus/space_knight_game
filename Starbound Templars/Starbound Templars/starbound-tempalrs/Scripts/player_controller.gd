extends CharacterBody2D

@export var speed = 300
@export var smoothing: float = 0.05

@onready var user_input = $UserInput
@onready var movement = $Movement

func _physics_process(delta):
    var input_direction = user_input.get_input_direction()
    movement.move(input_direction, speed, smoothing)
    move_and_slide()