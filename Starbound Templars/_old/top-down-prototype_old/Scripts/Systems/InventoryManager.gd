extends Node

var inventory: Inventory

func _ready():
	inventory = Inventory.new()
	add_child(inventory)

func get_inventory() -> Inventory:
	return inventory
