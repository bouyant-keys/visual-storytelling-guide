class_name RelationshipToggle extends Button


@export var button_element : ConfigManager.VisualElements

enum ToggleState { NEUTRAL, AFFINITY, CONTRAST }
@export var button_state := ToggleState.NEUTRAL

signal state_changed(element:ConfigManager.VisualElements, state:ToggleState)

func _on_press() -> void:
	button_state = clampi(button_state + 1, 0, 2) as ToggleState
	state_changed.emit(button_element, button_state)
	
	match(button_state):
		ToggleState.NEUTRAL:
			self_modulate = Color.WHITE
		ToggleState.AFFINITY:
			self_modulate = ConfigManager.RELATIONSHIP_AFFINITY_COLOR
		ToggleState.CONTRAST:
			self_modulate = ConfigManager.RELATIONSHIP_CONTRAST_COLOR

func set_state(state:ToggleState) ->void:
	button_state = state
	match(button_state):
		ToggleState.NEUTRAL:
			self_modulate = Color.WHITE
		ToggleState.AFFINITY:
			self_modulate = ConfigManager.RELATIONSHIP_AFFINITY_COLOR
		ToggleState.CONTRAST:
			self_modulate = ConfigManager.RELATIONSHIP_CONTRAST_COLOR
