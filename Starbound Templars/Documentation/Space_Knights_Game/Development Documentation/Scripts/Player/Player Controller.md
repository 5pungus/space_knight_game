
## Script:
[[Development Documentation/Scripts/Player/player.gd]]
## Overview:
This script manages the behavior of a 2D player character, including movement, health, abilities, and weapon mechanics. The character can move around, aim at the mouse cursor, switch weapons, use abilities, and regenerate health over time. It also integrates with a heads-up display (HUD) to visually represent the player's health and equipped weapon.

### Detailed Explanation of Each Function:

#### `func _ready()`:
This function is called when the scene containing the player node is fully initialized and ready. 
- **Group Assignment**: The player is added to the `"players"` group for easy identification during gameplay.
- **Screen Size**: Retrieves and stores the screen size to later use for movement boundaries.
- **Sprite Initialization**: Plays the "idle" animation when the game starts, ensuring the player appears in a neutral state.
- **Weapon Initialization**: The `weapon_node` is initialized by calling its `initialize` method, linking the weapon to the player character. This ensures the weapon knows which player it's attached to.
- **HUD Setup**: The player's current health is set in the HUD, and the health bar's maximum value is defined by the player's initial health.
- **Ability Initialization**: The `initialize_abilities()` function is called to load and prepare the player's abilities, which are defined in the scene as `PackedScene` objects.

#### `func initialize_abilities()`:
This function sets up the player's abilities. 
- It calls `instantiate_ability()` for each ability scene (such as `ability_1_scene`, `ability_2_scene`, etc.). 
- Each instantiated ability is assigned to a corresponding node (e.g., `ability_1_node`) to allow easy access for triggering abilities during gameplay.

#### `func instantiate_ability(ability_scene: PackedScene) -> Node`:
- **Instantiating Ability**: This function takes a `PackedScene` representing an ability and adds it as a child to the player. If the ability has an `initialize` method, it's called to prepare the ability for use. 
- **Return Value**: The instantiated ability node is returned so it can be referenced in other parts of the code. If the scene is not available, it returns `null`, preventing errors if abilities are not assigned.

#### `func get_input()`:
This function handles all player input for movement, weapon switching, and ability usage.
- **Movement**: Uses `Input.get_vector()` to detect movement input (using keys like `"left"`, `"right"`, `"up"`, and `"down"`). The player's velocity is set based on this input, and the movement direction is normalized to maintain consistent speed.
- **Animation**: The function switches between the "run" and "idle" animations based on whether the player is moving.
- **Weapon Switching**: The player can switch weapons by pressing keys corresponding to `"weapon1"`, `"weapon2"`, or `"weapon3"`. Each key press calls `switch_weapon()` with the appropriate `PackedScene` for the new weapon, and the HUD is updated to highlight the equipped weapon.
- **Ability Input**: The player can use abilities by pressing the keys mapped to `"ability1"`, `"ability2"`, `"ability3"`, or `"super_ability"`. When pressed, `use_ability()` is called to trigger the corresponding ability.

#### `func use_ability(ability_node: Node)`:
This function triggers the specified ability node.
- **Method Check**: It first checks if the ability node exists and has a `use` method. If both conditions are met, the method is called, triggering the ability's effect.

#### `func face_mouse()`:
This function ensures the player sprite visually faces the mouse cursor.
- **Mouse Position**: It calculates the angle between the player’s position and the mouse using `global_position.angle_to_point()`.
- **Sprite Flip**: If the angle to the mouse is less than $PI/2$, the sprite faces right; otherwise, it flips horizontally to face left. This gives the illusion that the player is looking at the mouse in a top-down perspective.

#### `func _physics_process(delta)`:
This is the main function that runs every frame and is responsible for:
- **Input Processing**: It calls `get_input()` to handle player movement, weapon switching, and ability usage each frame.
- **Movement**: Uses `move_and_slide()` to apply the player's velocity, which was calculated based on input.
- **Weapon Aiming**: Calls `handle_weapon_aiming()` to rotate and position the weapon correctly relative to the mouse.
- **Health Regeneration**: Calls `handle_health_regeneration()` to check whether the player should start regenerating health after taking damage.

#### `func handle_weapon_aiming()`:
This function manages how the weapon attached to the player faces the mouse.
- **Mouse Position**: Similar to `face_mouse()`, it calculates the angle between the player and the mouse.
- **Weapon Flip**: Depending on the angle, the weapon’s scale is flipped vertically to match the player’s sprite.
- **Weapon Rotation**: The weapon rotates to face the mouse, ensuring the player can aim in any direction.
- **Weapon Firing**: If the player presses the "fire" button and the weapon node has a `fire()` method, it triggers that method, making the weapon shoot. If the weapon instead has an `attack()` method, it triggers that.

#### `func handle_health_regeneration(delta)`:
This function governs the player's health regeneration over time.
- **Damage Timer**: It tracks the time since the player last took damage, incrementing `time_since_last_damage` each frame.
- **Regeneration Check**: Once enough time has passed (as defined by `health_regen_delay`), the player's health starts to regenerate at a rate set by `health_regen_rate`. Health is capped at 100, and the HUD is updated to reflect the new health value.

#### `func switch_weapon(new_weapon_scene: PackedScene)`:
This function changes the player's currently equipped weapon.
- **Old Weapon Removal**: If a weapon is already equipped, it is removed using `queue_free()`.
- **New Weapon Instantiation**: A new weapon is instantiated from the provided `PackedScene` and added as a child to the player.
- **Weapon Initialization**: If the new weapon has an `initialize()` method, it is called to set it up with the player.

#### `func take_damage(damage: int)`:
This function handles the player taking damage from an external source.
- **Health Reduction**: The player's health is reduced by the `damage` value, and the HUD is updated accordingly.
- **Death Check**: If health reaches 0 or below, the player dies, triggering the `die()` function.

#### `func die()`:
This function handles the player's death sequence.
- **Death Animation**: The player plays a "death" animation, signaling that they are no longer active.
- **Level Reset**: After a short delay, the level is restarted using `restart_level()`.

#### `func restart_level()`:
This function resets the level after the player dies.
- **Player Reset**: Calls `reset_player()` to restore the player's health and position.
- **Level-Specific Reset**: Placeholder code for resetting elements like enemies or collectibles in the level, to be implemented elsewhere.

#### `func reset_player()`:
This function restores the player to an initial state after death.
- **Health Reset**: Health is set back to 100, and the HUD is updated.
- **Position Reset**: The player's position is reset to a specific point on the map, preparing them to start fresh.

#### `func apply_knockback(force: Vector2)`:
This function applies a knockback force to the player.
- **Force Application**: The player’s velocity is increased by the given `force` vector, simulating a knockback effect. The movement is then handled by `move_and_slide()`.

#### `func _unhandled_input(event)`:
This is a placeholder for handling any unprocessed input events.

---

### Summary:
The script implements a comprehensive player control system, handling movement, health regeneration, damage, and weapon/ability usage. It ensures that the player can interact with both the environment and HUD seamlessly, while providing a solid foundation for adding further abilities, animations, or interactions.