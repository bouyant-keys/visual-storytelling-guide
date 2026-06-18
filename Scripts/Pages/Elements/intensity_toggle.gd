class_name IntensityToggle extends Button


@export var intensity_value := 1

signal intensity_changed(value:int)

func _on_pressed() -> void:
	intensity_changed.emit(intensity_value)

func set_toggle_state(on:bool) ->void:
	set_pressed_no_signal(on)
	if button_pressed:
		self_modulate = ConfigManager.get_current_element_color()
	else:
		self_modulate = Color.WHITE
