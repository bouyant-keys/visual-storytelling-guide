extends Panel

var content_data : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func on_element_selected(element:ConfigManager.VisualElements) ->void:
	var elements_data := DataManager.get_elements_data()
	var element_name := ConfigManager.get_element_name(element)
	
	# Retrieve data if there is any:
	if elements_data[element_name]:
		pass
	
	
