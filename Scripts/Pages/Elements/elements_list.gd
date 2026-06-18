extends VBoxContainer

var current_element_button : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_element_selected(element:ConfigManager.VisualElements) ->void:
	current_element_button.button_pressed = false
	
