```gdscript
extends Control

@onready var health_bar = $HealthBar
@onready var weapon1_highlight = $weapon_highlight/weapon1
@onready var weapon2_highlight = $weapon_highlight/weapon2
@onready var weapon3_highlight = $weapon_highlight/weapon3
@onready var super_weapon_highlight = $weapon_highlight/super_weapon

func _ready():
	weapon1_highlight.visible = true
	weapon2_highlight.visible = false
	weapon3_highlight.visible = false

func update_health(value):
	health_bar.value = value

	

func set_bar_max(value):
	health_bar.max_value = value

func weapon_highlight(weapon):
	if weapon == 1:
		weapon1_highlight.visible = true
		weapon2_highlight.visible = false
		weapon3_highlight.visible = false
	elif weapon == 2:
		weapon1_highlight.visible = false
		weapon2_highlight.visible = true
		weapon3_highlight.visible = false
	elif weapon == 3:
		weapon1_highlight.visible = false
		weapon2_highlight.visible = false
		weapon3_highlight.visible = true
		
	else:
		weapon1_highlight.visible = false
		weapon2_highlight.visible = false
		weapon3_highlight.visible = false
		
	
	

```