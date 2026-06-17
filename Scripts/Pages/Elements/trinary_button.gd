class_name TrinaryToggle extends Button


@export var button_element : ConfigManager.VisualElements

enum ToggleState { NEUTRAL, AFFINITY, CONTRAST }
@export var button_state := ToggleState.NEUTRAL

signal state_changed(state:ToggleState)

func _on_press() -> void:
	button_state = clampi(button_state + 1, 0, 2)
	state_changed.emit(button_element, button_state)
	
