# Scripts:
[[enemy.gd]]
[[enemy_ranged.gd]]
## Base Enemy Script
### Overview:
This script governs the behavior of an enemy in a 2D game, managing its movement, state transitions (idle, patrolling, chasing, and attacking), interaction with the player, health system, and knockback mechanics. The enemy patrols within a defined area, detects the player when nearby, chases the player, and attacks when within range. If the enemy's health reaches zero, it dies and plays a death animation.

### Detailed Explanation of Each Function:

#### `@export var`:
- **speed**: Controls how fast the enemy moves.
- **max_health**: The maximum health the enemy can have.
- **damage**: The amount of damage the enemy deals when attacking the player.
- **detection_radius**: The distance within which the enemy detects the player and begins chasing.
- **attack_radius**: The distance within which the enemy will stop chasing and start attacking.
- **chase_duration**: The maximum time the enemy will chase the player before returning to patrol.
- **patrol_radius**: Defines the area within which the enemy patrols.
- **patrol_wait_time**: The amount of time the enemy waits at a patrol point before moving to the next one.
- **knockback_resistance**: Determines how much resistance the enemy has to knockback effects.

#### `enum State { IDLE, PATROL, CHASE, ATTACK }`:
This enumerates the different states the enemy can be in:
- **IDLE**: The enemy is stationary and waits before patrolling again.
- **PATROL**: The enemy moves within a defined radius, searching for the player.
- **CHASE**: The enemy actively pursues the player when detected.
- **ATTACK**: The enemy attacks the player when within range.

#### `@onready`:
- **attack_timer**: Timer that controls the interval between attacks.
- **detection_area**: Area used to detect if the player is within range of the enemy.
- **attack_area**: Area used to check if the player is close enough to be attacked.
- **animated_sprite**: The sprite that displays the enemy's animations.
- **health_bar**: Manages the enemy's health bar display.

#### `func _ready()`:
This function initializes the enemy when the scene is loaded:
- **Health Initialization**: Sets the enemy’s health to its maximum value and updates the health bar.
- **Player Detection**: Locates the player in the scene for future reference.
- **Setup Areas**: Calls `setup_detection_area()` and `setup_attack_area()` to configure the enemy's detection and attack radii.
- **Patrolling**: Sets a new random patrol target for the enemy to move towards.
- **Sprite Setup**: Sets the initial animation to "idle".

#### `func _process(delta)`:
This function runs every frame and updates the enemy's behavior:
- **State Machine**: Depending on the current state (`IDLE`, `PATROL`, `CHASE`, or `ATTACK`), it calls the corresponding behavior function (e.g., `idle_behavior()`, `patrol_behavior()`, etc.).
- **Movement and Animation**: Updates the enemy's movement and adjusts the sprite animation based on velocity.
- **Player Detection**: Calls `check_player_in_range()` to see if the player is close enough for the enemy to chase.

#### `func update_animation()`:
Updates the enemy’s animation based on its state and movement:
- **Death Animation**: Plays the death animation if the enemy is dead.
- **Movement Animations**: Plays "run" if the enemy is moving and "idle" if it's stationary.
- **Sprite Flip**: Flips the sprite horizontally depending on the direction the enemy is moving.

#### `func check_player_in_range()`:
Checks whether the player is within the enemy’s detection radius:
- If the player is detected, the enemy switches to the `CHASE` state.

#### `func idle_behavior(delta)`:
Controls the enemy’s idle behavior:
- **Patrol Wait**: Increments a timer during idle. When the wait time expires, the enemy sets a new patrol target and transitions to the `PATROL` state.

#### `func patrol_behavior(delta)`:
Controls the enemy’s patrol movement:
- **Movement**: The enemy moves towards a randomly selected patrol point at half speed.
- **Target Reached**: Once the patrol target is reached, the enemy returns to the `IDLE` state and waits before selecting a new patrol target.

#### `func chase_behavior(delta)`:
Controls the enemy’s behavior when chasing the player:
- **Chase Movement**: The enemy moves towards the player’s last known position.
- **Attack Transition**: If the player is within attack range, the enemy transitions to the `ATTACK` state. If the player is no longer detectable, the enemy returns to patrolling.

#### `func attack_behavior(delta)`:
Controls the enemy’s attack logic:
- **Damage**: The enemy deals damage to the player if within attack range.
- **Attack Cooldown**: The enemy cannot attack continuously; it waits for the `attack_timer` to timeout before attacking again.
- **Return to Chase**: If the player moves out of attack range, the enemy returns to chasing.

#### `func set_new_patrol_target()`:
Generates a new random position within the patrol radius for the enemy to move towards during patrolling.

#### `func setup_detection_area()`:
Sets the size of the enemy's detection area to match the detection radius using a circular collision shape.

#### `func setup_attack_area()`:
Sets the size of the enemy's attack area to match the attack radius using a circular collision shape.

#### `func take_damage(dmg: int)`:
This function handles the enemy taking damage:
- **Health Reduction**: Decreases the enemy’s health and updates the health bar.
- **Death Check**: If the enemy’s health reaches 0, it triggers the `die()` function.
- **Chase Reaction**: If damaged and not dead, the enemy will start chasing the player, even if it wasn’t already.

#### `func apply_knockback(force: Vector2)`:
This function applies a knockback effect to the enemy based on the given `force`:
- **Knockback Resistance**: Reduces the applied knockback by the enemy's `knockback_resistance` value.

#### `func _on_attack_timer_timeout()`:
Resets the `can_attack` variable to `true`, allowing the enemy to attack again after the cooldown.

#### `func _on_detection_area_body_entered(body)`:
This function is called when a body enters the enemy’s detection area:
- If the detected body belongs to the `"players"` group, the enemy starts chasing the player.

#### `func _on_detection_area_body_exited(body)`:
This function is called when a body exits the enemy’s detection area:
- If the player leaves the detection area, the enemy stores the player’s last known position to continue chasing for a short time.

#### `func die()`:
Handles the enemy's death:
- **Death Logic**: Sets the `dead` flag to `true`, plays the death animation, and waits for it to finish.
- **Removal**: After the death animation completes, the enemy is removed from the scene with `queue_free()`.

---

### Summary:
The script manages the enemy's AI, including patrolling, chasing, and attacking the player. The enemy can detect the player within a set radius, engage in combat, take damage, and die. Its movement and behavior are controlled by a state machine that switches between different states based on player interactions. The knockback and health systems make the enemy more dynamic, while animations keep the visual feedback in sync with gameplay actions.

## Ranged Enemy
Here’s a detailed explanation of each function in your ranged enemy script, following the same structure as I used for the regular enemy. This will include an overview, function descriptions, and potential improvements:

### Function: `_ready()`
**Description:**
- Initializes the enemy and sets up the detection area.
- Establishes connections for the detection area signals to detect the player.
- Initializes the enemy's health and health bar, as well as the weapon node if present.

**Potential Improvements:**
- Ensure `weapon_node` is properly initialized, and handle potential errors if the player node is not found.

```gdscript
func _ready():
    player = get_node("/root/Main/Player")  # Ensure this path is correct based on your scene setup
    setup_detection_area()
    randomize()  # This helps ensure random patrol targets
    set_new_patrol_target()  # Sets a new patrol target
    
    # Connect the detection area signals to detect the player
    detection_area.connect("body_entered", Callable(self, "_on_detection_area_body_entered"))
    detection_area.connect("body_exited", Callable(self, "_on_detection_area_body_exited"))
    
    # Initialize the weapon if present
    if weapon_node:
        weapon_node.initialize(self)  # Make sure the weapon script has an 'initialize' method
    
    # Initialize the enemy's health and health bar
    health = max_health
    health_bar.initialize(health, max_health)
```

### Function: `_process(delta)`
**Description:**
- Runs every frame to update the enemy's behavior based on the current state.
- Uses `match` to switch between different behavior functions (e.g., idle, patrol, chase).
- Also updates movement, checks for the player’s presence, and triggers animations.

**Potential Improvements:**
- The `move_and_slide()` call should include the velocity passed as an argument to ensure smooth movement.
  
```gdscript
func _process(delta):
    if dead:
        return  # Skip processing if the enemy is dead
    
    # Switch behavior based on the current state
    match current_state:
        State.IDLE:
            idle_behavior(delta)
        State.PATROL:
            patrol_behavior(delta)
        State.CHASE:
            chase_behavior(delta)
        State.ATTACK:
            attack_behavior(delta)
        State.RETREAT:
            retreat_behavior(delta)

    check_player_in_range()  # Checks if the player is within detection range
    move_and_slide()  # Moves the enemy
    update_animation()  # Updates the sprite animation
```

### Function: `update_animation()`
**Description:**
- Updates the enemy’s animation based on the current movement and state.
- Ensures the enemy sprite flips direction towards the player and plays the appropriate animation.

**Potential Improvements:**
- You can add specific animations for different states, like `attack` or `retreat`, for more visual feedback.

```gdscript
func update_animation():
    if dead:
        animated_sprite.play("death")
    elif velocity.length() > 0:
        animated_sprite.play("run")
    else:
        animated_sprite.play("idle")
    
    # Face the player if they're within detection range
    if is_instance_valid(player) and global_position.distance_to(player.global_position) <= detection_radius:
        var direction_to_player = player.global_position - global_position
        animated_sprite.flip_h = direction_to_player.x < 0  # Flip the sprite horizontally
        if weapon_node:
            weapon_node.rotation = direction_to_player.angle()  # Rotate the weapon to face the player
```

### Function: `check_player_in_range()`
**Description:**
- Determines the distance between the enemy and the player to decide on state transitions (e.g., attack, retreat, chase).
  
**Potential Improvements:**
- Add checks to prevent redundant state changes and ensure smoother transitions between states.

```gdscript
func check_player_in_range():
    if is_instance_valid(player):
        var distance = global_position.distance_to(player.global_position)
        if distance <= detection_radius:
            if distance <= retreat_distance:
                current_state = State.RETREAT
            elif distance <= attack_radius:
                current_state = State.ATTACK
            else:
                current_state = State.CHASE
```

### Function: `chase_behavior(delta)`
**Description:**
- Moves the enemy towards the player when in `CHASE` state.
- Tracks the last known position of the player and adjusts velocity accordingly.

**Potential Improvements:**
- Implement a smoother transition when switching from `CHASE` to another state, such as easing the velocity when approaching the player.

```gdscript
func chase_behavior(delta):
    if is_instance_valid(player):
        last_known_player_position = player.global_position
        var direction = (last_known_player_position - global_position).normalized()
        velocity = direction * speed  # Move towards the player
```

### Function: `get_target_position()`
**Description:**
- Retrieves the target position, which is either the player's position or the enemy's current position if the player is not valid.
  
**Potential Improvements:**
- None, as this function is simple and straightforward.

```gdscript
func get_target_position() -> Vector2:
    return player.global_position if is_instance_valid(player) else global_position
```

### Function: `attack_behavior(delta)`
**Description:**
- Stops the enemy and fires the weapon at the player when in `ATTACK` state.
  
**Potential Improvements:**
- Add a firing cooldown to prevent continuous firing.

```gdscript
func attack_behavior(delta):
    if is_instance_valid(player):
        var direction = (player.global_position - global_position).normalized()
        velocity = Vector2.ZERO  # Stop moving during the attack
        if weapon_node and weapon_node.has_method("fire"):
            weapon_node.fire()  # Fire the weapon at the player
    else:
        current_state = State.PATROL  # If the player is not valid, return to patrol
```

### Function: `retreat_behavior(delta)`
**Description:**
- Moves the enemy away from the player when too close.
  
**Potential Improvements:**
- Consider adding burst movement for retreat or moving towards a safe zone rather than a random direction.

```gdscript
func retreat_behavior(delta):
    if is_instance_valid(player):
        var direction = (global_position - player.global_position).normalized()
        velocity = direction * speed  # Move away from the player
        if weapon_node and weapon_node.has_method("fire"):
            weapon_node.fire()  # Continue firing while retreating
    else:
        current_state = State.PATROL  # If the player is not valid, return to patrol
```

### Function: `idle_behavior(delta)`
**Description:**
- Waits for the patrol timer to finish before transitioning to the `PATROL` state.

**Potential Improvements:**
- You could introduce random idle behaviors, such as looking around or changing animations.

```gdscript
func idle_behavior(delta):
    patrol_wait_timer += delta  # Increment the timer
    if patrol_wait_timer >= patrol_wait_time:
        set_new_patrol_target()
        current_state = State.PATROL  # After waiting, start patrolling
```

### Function: `patrol_behavior(delta)`
**Description:**
- Moves the enemy towards a random patrol target and switches back to `IDLE` once the target is reached.

**Potential Improvements:**
- None, as this logic is simple and effective.

```gdscript
func patrol_behavior(delta):
    var direction = (patrol_target - global_position).normalized()
    velocity = direction * speed * 0.5  # Move at half speed when patrolling

    if global_position.distance_to(patrol_target) < 5:
        current_state = State.IDLE  # Return to idle once the patrol point is reached
        patrol_wait_timer = 0
```

### Function: `set_new_patrol_target()`
**Description:**
- Sets a new random patrol target within the defined patrol radius.

**Potential Improvements:**
- You could make the patrol radius dynamic or adjust based on external factors.

```gdscript
func set_new_patrol_target():
    var random_offset = Vector2(randf_range(-patrol_radius, patrol_radius), randf_range(-patrol_radius, patrol_radius))
    patrol_target = global_position + random_offset  # Set a new random target within the patrol radius
```

### Function: `setup_detection_area()`
**Description:**
- Sets up the detection area for the enemy by configuring the collision shape.

**Potential Improvements:**
- Ensure the detection shape is correctly applied based on the enemy's detection radius.

```gdscript
func setup_detection_area():
    var shape = CircleShape2D.new()
    shape.radius = detection_radius  # Set the detection radius
    detection_area.get_node("CollisionShape2D").shape = shape  # Assign the shape to the collision shape node
```

### Function: `take_damage(dmg: int)`
**Description:**
- Handles the enemy taking damage, updating the health, and checking if the enemy should die.
  
**Potential Improvements:**
- Add an invulnerability period after taking damage to avoid rapid consecutive hits.

```gdscript
func take_damage(dmg: int):
    if not dead:
        health -= dmg
        health_bar.update_health(health)  # Update the health bar
        print("Ranged enemy took", dmg, "damage. Health is now", health)
        if health <= 0:
            die()  # Kill the enemy if health drops to 0
        else:
            current_state = State.CHASE  # Chase the player after taking damage
            last_known_player_position = player.global_position if is_instance_valid(player) else global_position
```

### Function: `apply_knockback(force: Vector2)`
**Description:**
- Applies knockback to the enemy when hit, modifying the velocity based