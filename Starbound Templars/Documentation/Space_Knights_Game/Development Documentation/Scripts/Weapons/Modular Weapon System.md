## Scripts
[[weapon_template.gd]]

---

# **Weapon.gd Documentation**

## **Overview**

This script defines a weapon system for a 2D game in Godot Engine. The weapon can fire projectiles with specified properties, including damage, speed, and spread. It uses a timer to control the firing rate and an animated sprite for visual feedback. The script is designed to be attached to a `Node3D` and interacts with other nodes such as the projectile scene and the owner node (typically a player or an entity).

## **Exported Variables**

### **@export var number_of_projectiles: int = 1**
- **Description:** Specifies the number of projectiles to fire with each shot.
- **Default Value:** `1`
- **Usage:** Set this value in the Godot editor to control how many projectiles are fired simultaneously.

### **@export var damage: float = 10.0**
- **Description:** Defines the amount of damage each projectile inflicts upon hitting a target.
- **Default Value:** `10.0`
- **Usage:** Adjust this value to change the damage output of the weapon.

### **@export var projectile_speed: float = 1000.0**
- **Description:** Determines the speed at which the projectiles travel.
- **Default Value:** `1000.0`
- **Usage:** Modify this value to increase or decrease the projectile speed.

### **@export var spread: float = 0.0**
- **Description:** Controls the spread angle of the projectiles. A non-zero value will cause projectiles to scatter.
- **Default Value:** `0.0`
- **Usage:** Set this value to create a spread effect for the projectiles, making them deviate from a straight line.

### **@export var projectile_scene: PackedScene**
- **Description:** The scene that defines the projectile's appearance and behavior.
- **Usage:** Assign a `PackedScene` resource that contains the projectile’s node hierarchy. This scene will be instantiated each time a projectile is fired.

### **@export var fire_rate: float = 0.2**
- **Description:** Time interval between consecutive shots (in seconds).
- **Default Value:** `0.2`
- **Usage:** Adjust this value to control how frequently the weapon can fire.

## **On-Ready Variables**

### **@onready var fire_point = $FirePoint**
- **Description:** Reference to a node named `FirePoint` which indicates the position from where projectiles are fired.
- **Usage:** Used to get the starting position for the projectiles.

### **@onready var fire_timer = $FireRateTimer**
- **Description:** Reference to a `Timer` node named `FireRateTimer` that manages the firing rate.
- **Usage:** Controls the delay between shots to implement the weapon's fire rate.

### **@onready var animated_sprite = $AnimatedSprite2D**
- **Description:** Reference to an `AnimatedSprite2D` node that provides visual feedback by playing animations.
- **Usage:** Used to play different animations (e.g., "idle" or "firing") based on the weapon's state.

## **Instance Variables**

### **var can_fire: bool = true**
- **Description:** Flag that indicates whether the weapon is allowed to fire.
- **Default Value:** `true`
- **Usage:** Prevents the weapon from firing continuously without respecting the `fire_rate`.

### **var owner_node : Node**
- **Description:** Reference to the node that owns or controls this weapon, usually the player or an entity.
- **Usage:** Used to determine the weapon’s behavior based on the owner (e.g., player inputs).

### **var target_position: Vector2**
- **Description:** The position where the weapon is aiming or firing.
- **Usage:** Updates the direction in which the projectiles are fired.

## **Functions**

### **func _ready():**
- **Description:** Initializes the weapon when it is added to the scene tree.
- **Behavior:**
  - Sets up the `fire_timer` to use the specified `fire_rate` and marks it as a one-shot timer.
  - Connects the `timeout` signal of `fire_timer` to the `_on_fire_timer_timeout()` function if it is not already connected.
  - Starts the `animated_sprite` in the "idle" animation.
  - Prints the projectile speed for debugging purposes.
- **Purpose:** Prepares the weapon for firing by configuring the timer and animations.

### **func initialize(owner):**
- **Description:** Sets the `owner_node` to the specified `owner`.
- **Parameters:**
  - `owner`: The node that will control this weapon (e.g., a player or another entity).
- **Purpose:** Links the weapon to its owner, allowing it to interact with the owner’s properties and methods.

### **func _process(delta):**
- **Description:** Updates the weapon’s logic every frame.
- **Behavior:**
  - If `owner_node` is a `CharacterBody2D` in the "players" group, updates `target_position` to the global mouse position.
  - If `owner_node` has a `get_target_position` method, retrieves `target_position` from that method.
  - Adjusts the weapon’s orientation to face `target_position`.
  - If the owner is a player, and the "fire" action is pressed while `can_fire` is true, triggers the `fire()` function.
- **Parameters:**
  - `delta`: Time elapsed since the last frame, used to handle frame-dependent calculations.
- **Purpose:** Handles targeting and firing input based on the owner’s status and actions.

### **func fire():**
- **Description:** Initiates the firing process if the weapon is in a state that allows firing.
- **Behavior:**
  - Calls `spawn_projectile()` to create projectiles.
  - Sets `can_fire` to false to prevent firing until the timer resets.
  - Starts the `fire_timer` to allow firing again after the specified `fire_rate`.
  - Plays the "firing" animation using `animated_sprite`.
- **Purpose:** Manages the firing of projectiles and controls the weapon’s state to adhere to the fire rate.

### **func spawn_projectile():**
- **Description:** Creates and initializes projectiles according to the weapon’s settings.
- **Behavior:**
  - Loops `number_of_projectiles` times to spawn the specified number of projectiles.
  - Instantiates a new projectile scene for each projectile.
  - Calculates the projectile direction and applies spread by rotating the direction vector.
  - Sets the projectile’s rotation to face the target position.
  - Initializes the projectile with its start position, damage, speed, owner, and direction.
  - Adds the projectile to the scene tree as a child of the root node.
  - Prints debugging information about the projectile’s damage and speed.
  - Plays the "firing" animation.
- **Purpose:** Handles the creation and configuration of projectiles based on the weapon’s settings and current state.

### **func _on_fire_timer_timeout():**
- **Description:** Callback function triggered when the `fire_timer` times out.
- **Behavior:**
  - Resets `can_fire` to true, allowing the weapon to fire again.
- **Purpose:** Enables the weapon to fire again after the interval defined by `fire_rate`.

### **func reset_fire_state():**
- **Description:** Manually resets the weapon’s firing state.
- **Behavior:**
  - Sets `can_fire` to true to allow immediate firing.
  - Stops the `fire_timer`, effectively resetting the firing cooldown.
  - Prints a message indicating that the fire state has been manually reset.
- **Purpose:** Provides a way to reset the weapon’s firing state outside the normal firing cooldown mechanism.

---
