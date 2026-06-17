extends Node

var data : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Retrieve data from local machine here...
	pass

# TODO: implement ctrl+s for saving
func _unhandled_input(event: InputEvent) -> void:
	pass

func get_elements_data() ->Dictionary:
	return data["elements"]
