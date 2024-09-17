## Scripts
[[EnemyHealthBar.gd]]

---
## **Overview**

This script manages a dynamic health bar, adjusting its size based on the player's current health. It provides a visual representation of health by modifying the width of the `ProgressBar` node and ensures the health bar reflects changes in health accurately.

## **Exported Variables**

### **@export var min_width: float = 50.0**
- **Description:** The minimum width of the health bar when health is at its lowest.
- **Default Value:** `50.0`
- **Usage:** Adjust this value to set the minimum width of the health bar. It scales with health to ensure a consistent visual representation.

### **@export var max_width: float = 100.0**
- **Description:** The maximum width of the health bar when health is at its fullest.
- **Default Value:** `100.0`
- **Usage:** Adjust this value to set the maximum width of the health bar. It scales with health to ensure the bar visually represents the full health.

## **On-Ready Variables**

### **@onready var progress_bar = $ProgressBar**
- **Description:** Reference to the `ProgressBar` node used to visually display the health.
- **Usage:** Used to update the value and size of the health bar based on the player’s health.

## **Instance Variables**

### **var max_health: float = 100.0**
- **Description:** The maximum health value that the health bar can represent.
- **Default Value:** `100.0`
- **Usage:** Initialized in the `initialize` function and used to calculate health ratios.

## **Functions**

### **func initialize(initial_health: float, max_health: float):**
- **Description:** Sets up the health bar with initial and maximum health values.
- **Parameters:**
  - `initial_health`: The initial health value to set on the health bar.
  - `max_health`: The maximum health value for the health bar.
- **Behavior:**
  - Updates `self.max_health` with the provided `max_health` value.
  - Sets the `max_value` property of `progress_bar` to the new `max_health`.
  - Calls `update_health(initial_health)` to initialize the health bar with the starting health.
- **Purpose:** Initializes the health bar to reflect the correct maximum and current health values.

### **func update_health(current_health: float):**
- **Description:** Updates the health bar to reflect the current health value.
- **Parameters:**
  - `current_health`: The current health value to display on the health bar.
- **Behavior:**
  - Sets the `value` property of `progress_bar` to the `current_health`.
  - Calculates the `health_ratio` as the fraction of `current_health` to `max_health`.
  - Uses `lerp` (linear interpolation) to determine the new width of the health bar based on `health_ratio`.
  - Sets `progress_bar.size.x` to `new_width` to adjust the width of the health bar.
  - Adjusts `progress_bar.position.x` to center the health bar by setting its position to `-new_width / 2`.
- **Purpose:** Ensures the health bar’s width and value visually represent the current health relative to the maximum health.

---
