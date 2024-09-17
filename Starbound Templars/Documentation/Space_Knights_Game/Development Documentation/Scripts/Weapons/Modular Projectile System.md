## Script
[[projectile_template.gd]]


---

# **Projectile.gd Documentation**

## **Overview**

This script is designed to manage the behavior of a projectile in a 2D game. It handles movement, collision detection, visual effects, and the projectile's lifecycle. The projectile can inflict damage, interact with other objects, and visually represent its presence through effects such as trails and glow.

## **Variables**

### **var speed: float**
- **Description:** The speed at which the projectile moves.
- **Usage:** Set this value when initializing the projectile to control its movement speed.

### **var damage: float**
- **Description:** The amount of damage the projectile deals upon impact.
- **Usage:** Set this value when initializing the projectile to define its damage output.

### **var shooter = Node**
- **Description:** The node that fired the projectile, typically the weapon or character responsible for it.
- **Usage:** Used to check if the projectile should affect the object it collides with (i.e., avoid damaging the shooter).

### **var spread_direction: Vector2**
- **Description:** The direction in which the projectile travels, taking into account any spread effect.
- **Usage:** Set this value during initialization to control the trajectory of the projectile.

### **@export var time_limit: float = 1**
- **Description:** The maximum time (in seconds) before the projectile is automatically destroyed.
- **Default Value:** `1`
- **Usage:** Adjust this value to control how long the projectile remains active before being destroyed.

### **@export var time_elapsed: float = 0.0**
- **Description:** The elapsed time since the projectile was created, used to manage its lifetime.
- **Default Value:** `0.0`
- **Usage:** Automatically updated each frame to track the projectile's age.

### **@export var glow_effect: PackedScene**
- **Description:** The scene resource for the projectile's glow effect.
- **Usage:** Assign a `PackedScene` that defines the glow effect to be instantiated when the projectile is created.

### **@export var trail_effect: PackedScene**
- **Description:** The scene resource for the projectile's trail effect.
- **Usage:** Assign a `PackedScene` that defines the trail effect to be instantiated if applicable.

### **var trail_instance: GPUParticles2D**
- **Description:** Instance of the trail effect, used to visually represent the projectile’s path.
- **Usage:** Created and configured during initialization if the trail effect is assigned.

### **@onready var collision_shape = $CollisionShape2D**
- **Description:** Reference to the `CollisionShape2D` node, which defines the projectile’s collision area.
- **Usage:** Used for detecting collisions with other objects.

### **@onready var animated_sprite = $AnimatedSprite2D**
- **Description:** Reference to the `AnimatedSprite2D` node, used for visual animations of the projectile.
- **Usage:** Controls the animation states such as flying, impact, and dead.

## **Functions**

### **func _ready():**
- **Description:** Initializes the projectile’s animation when it is added to the scene.
- **Behavior:**
  - Starts the "flying" animation using `animated_sprite`.
- **Purpose:** Sets up the visual representation of the projectile as it begins its lifecycle.

### **func initialize(pos: Vector2, dmg: float, spd: float, owner: Node, sprd: Vector2):**
- **Description:** Sets up the projectile with initial values and effects.
- **Parameters:**
  - `pos`: The initial position of the projectile.
  - `dmg`: The damage value to be dealt by the projectile.
  - `spd`: The speed at which the projectile moves.
  - `owner`: The node that fired the projectile.
  - `sprd`: The direction of travel, including spread effect.
- **Behavior:**
  - Sets the projectile’s global position to `pos`.
  - Configures `speed`, `damage`, `shooter`, and `spread_direction`.
  - Instantiates and adds a glow effect if `glow_effect` is assigned.
  - Instantiates and adds a trail effect if `trail_effect` is assigned and the projectile is inside the scene tree.
- **Purpose:** Initializes the projectile with necessary properties and visual effects.

### **func _process(delta):**
- **Description:** Updates the projectile’s state every frame.
- **Parameters:**
  - `delta`: The time elapsed since the last frame.
- **Behavior:**
  - Moves the projectile in the direction of `spread_direction` by updating its position based on `speed` and `delta`.
  - Increments `time_elapsed` to track the projectile’s age.
  - Calls `destroy()` if `time_elapsed` exceeds `time_limit`.
  - Updates the position of `trail_instance` if it exists.
- **Purpose:** Manages movement, lifetime, and visual effects of the projectile.

### **func _on_body_entered(body):**
- **Description:** Handles collisions with other bodies.
- **Parameters:**
  - `body`: The body that the projectile has collided with.
- **Behavior:**
  - Checks if the collided body is not the shooter and if it has a `take_damage` method.
  - Calls `take_damage(damage)` on the body to apply damage.
  - Starts fading out the trail effect if it exists.
  - Calls `destroy()` to remove the projectile.
  - If the body is the shooter, calls `destroy()` without applying damage.
- **Purpose:** Applies damage to the target upon collision and handles cleanup.

### **func _on_screen_exited():**
- **Description:** Handles the case when the projectile exits the screen boundaries.
- **Behavior:**
  - Calls `destroy()` to remove the projectile from the scene.
- **Purpose:** Ensures the projectile is destroyed if it goes out of view, preventing it from lingering in the game world.

### **func destroy():**
- **Description:** Handles the finalization and removal of the projectile.
- **Behavior:**
  - Stops the projectile’s movement by setting `speed` to 0 and `spread_direction` to `Vector2.ZERO`.
  - If a `trail_instance` exists, starts fading it out, plays the "impact" animation, and waits for the animation to finish before playing the "dead" animation and freeing the projectile.
  - If no `trail_instance` exists, directly plays the "impact" animation, waits for it to finish, then plays the "dead" animation and frees the projectile.
- **Purpose:** Manages the projectile’s visual effects and ensures it is properly removed from the game world.

---

