extends Node

var parent: CharacterBody2D

func _ready():
    parent = get_parent()

func move(direction: Vector2, speed: float, smoothing: float):
    parent.velocity = parent.velocity.lerp(direction * speed, smoothing)
