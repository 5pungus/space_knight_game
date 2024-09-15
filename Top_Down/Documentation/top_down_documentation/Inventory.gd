class_name Inventory
extends Node



signal weapon_equipped(slot: int, weapon: PackedScene)
signal weapon_unequipped(slot: int)
signal weapon_added(weapon: PackedScene)
signal weapon_removed(weapon: PackedScene)

const MAX_EQUIPPED_WEAPONS = 3

var stored_weapons: Array[PackedScene] = []
var equipped_weapons: Array[PackedScene] = [null, null, null]

func add_weapon(weapon: PackedScene) -> bool:
	if weapon not in stored_weapons:
		stored_weapons.append(weapon)
		emit_signal("weapon_added", weapon)
		return true
	return false

func remove_weapon(weapon: PackedScene) -> bool:
	if weapon in stored_weapons:
		stored_weapons.erase(weapon)
		# Unequip the weapon if it's currently equipped
		for i in range(MAX_EQUIPPED_WEAPONS):
			if equipped_weapons[i] == weapon:
				unequip_weapon(i)
		emit_signal("weapon_removed", weapon)
		return true
	return false

func equip_weapon(weapon: PackedScene, slot: int) -> bool:
	if slot < 0 or slot >= MAX_EQUIPPED_WEAPONS:
		return false
	if weapon not in stored_weapons:
		return false
	
	# Unequip the current weapon in the slot if there is one
	if equipped_weapons[slot] != null:
		unequip_weapon(slot)
	
	equipped_weapons[slot] = weapon
	emit_signal("weapon_equipped", slot, weapon)
	return true

func unequip_weapon(slot: int) -> bool:
	if slot < 0 or slot >= MAX_EQUIPPED_WEAPONS:
		return false
	if equipped_weapons[slot] == null:
		return false
	
	var weapon = equipped_weapons[slot]
	equipped_weapons[slot] = null
	emit_signal("weapon_unequipped", slot)
	return true

func get_equipped_weapon(slot: int) -> PackedScene:
	if slot < 0 or slot >= MAX_EQUIPPED_WEAPONS:
		return null
	return equipped_weapons[slot]

func get_stored_weapons() -> Array[PackedScene]:
	return stored_weapons.duplicate()

func get_equipped_weapons() -> Array[PackedScene]:
	return equipped_weapons.duplicate()

func has_weapon(weapon: PackedScene) -> bool:
	return weapon in stored_weapons

func get_weapon_count() -> int:
	return stored_weapons.size()

func clear_inventory():
	stored_weapons.clear()
	for i in range(MAX_EQUIPPED_WEAPONS):
		unequip_weapon(i)

func save() -> Dictionary:
	var save_data = {
		"stored_weapons": [],
		"equipped_weapons": []
	}
	
	for weapon in stored_weapons:
		save_data["stored_weapons"].append(weapon.resource_path)
	
	for i in range(MAX_EQUIPPED_WEAPONS):
		if equipped_weapons[i] != null:
			save_data["equipped_weapons"].append(equipped_weapons[i].resource_path)
		else:
			save_data["equipped_weapons"].append(null)
	
	return save_data

func load(save_data: Dictionary):
	clear_inventory()
	
	for weapon_path in save_data["stored_weapons"]:
		var weapon = load(weapon_path) as PackedScene
		if weapon:
			add_weapon(weapon)
	
	for i in range(min(MAX_EQUIPPED_WEAPONS, save_data["equipped_weapons"].size())):
		var weapon_path = save_data["equipped_weapons"][i]
		if weapon_path != null:
			var weapon = load(weapon_path) as PackedScene
			if weapon:
				equip_weapon(weapon, i)
