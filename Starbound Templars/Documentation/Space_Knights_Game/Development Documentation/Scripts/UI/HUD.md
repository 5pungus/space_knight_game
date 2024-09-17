## Script:
[[hud.gd]]


---

# **HUDControl.gd Documentation**

## **Overview**

This script is responsible for managing the HUD elements related to health and weapon selection highlights. It controls the visibility of weapon highlights and updates the health bar based on game events.

## **On-Ready Variables**

### **@onready var health_bar = $HealthBar**
- **Description:** Reference to the `HealthBar` node, which displays the player’s current health.
- **Usage:** Used to update and manage the player’s health display.

### **@onready var weapon1_highlight = $weapon_highlight/weapon1**
- **Description:** Reference to the highlight node for Weapon 1.
- **Usage:** Controls the visibility of the highlight for Weapon 1.

### **@onready var weapon2_highlight = $weapon_highlight/weapon2**
- **Description:** Reference to the highlight node for Weapon 2.
- **Usage:** Controls the visibility of the highlight for Weapon 2.

### **@onready var weapon3_highlight = $weapon_highlight/weapon3**
- **Description:** Reference to the highlight node for Weapon 3.
- **Usage:** Controls the visibility of the highlight for Weapon 3.

### **@onready var super_weapon_highlight = $weapon_highlight/super_weapon**
- **Description:** Reference to the highlight node for the Super Weapon.
- **Usage:** Controls the visibility of the highlight for the Super Weapon.

## **Functions**

### **func _ready():**
- **Description:** Initializes the HUD when the node is added to the scene tree.
- **Behavior:**
  - Sets the visibility of `weapon1_highlight` to `true`, indicating that Weapon 1 is the default or currently selected weapon.
  - Sets the visibility of `weapon2_highlight` and `weapon3_highlight` to `false`, hiding the highlights for Weapon 2 and Weapon 3.
- **Purpose:** Ensures that the HUD displays the correct initial state for weapon selection highlights.

### **func update_health(value):**
- **Description:** Updates the value of the health bar to reflect the player’s current health.
- **Parameters:**
  - `value`: The new health value to set on the `health_bar`.
- **Behavior:**
  - Sets the `value` property of `health_bar` to the provided `value`.
- **Purpose:** Reflects changes in the player’s health in the HUD.

### **func set_bar_max(value):**
- **Description:** Sets the maximum value of the health bar.
- **Parameters:**
  - `value`: The new maximum value for the health bar.
- **Behavior:**
  - Sets the `max_value` property of `health_bar` to the provided `value`.
- **Purpose:** Adjusts the maximum value of the health bar, typically when the player’s maximum health changes.

### **func weapon_highlight(weapon):**
- **Description:** Updates the visibility of weapon highlights based on the selected weapon.
- **Parameters:**
  - `weapon`: An integer representing the selected weapon (1, 2, 3, or any other number for none).
- **Behavior:**
  - If `weapon` is `1`, sets `weapon1_highlight` to visible and hides the other weapon highlights.
  - If `weapon` is `2`, sets `weapon2_highlight` to visible and hides the other weapon highlights.
  - If `weapon` is `3`, sets `weapon3_highlight` to visible and hides the other weapon highlights.
  - If `weapon` is any other value, hides all weapon highlights.
- **Purpose:** Provides visual feedback to the player by highlighting the currently selected weapon.

---
