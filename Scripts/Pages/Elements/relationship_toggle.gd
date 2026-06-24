class_name RelationshipToggle extends Button


@export var button_element : ConfigManager.VisualElements
@export var button_state := ConfigManager.RelationshipState.NEUTRAL

signal state_changed(element:ConfigManager.VisualElements, state:ConfigManager.RelationshipState)

func _on_press() -> void:
	button_state = posmod(button_state + 1, 3) as ConfigManager.RelationshipState
	state_changed.emit(button_element, button_state)
	
	self_modulate = ConfigManager.get_relationship_color(button_state)

func set_state(state:ConfigManager.RelationshipState) ->void:
	button_state = state
	self_modulate = ConfigManager.get_relationship_color(button_state)
