extends Node

const DEFAULT_DATA := preload("res://Scripts/DefaultData.json")
const ELEMENTS_KEY := "Elements"

var data : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Retrieve data from local machine here...
	
	
	var json = JSON.new()
	var error = json.parse(JSON.stringify(DEFAULT_DATA.data))
	if error == OK:
		print("Read in default data.")
		print(json.data)
		data = json.data

# TODO: implement ctrl+s for saving
func _unhandled_input(event: InputEvent) -> void:
	pass

func get_elements_data() ->Dictionary:
	return data[ELEMENTS_KEY]

func set_elements_data(e_data) ->void:
	data[ELEMENTS_KEY] = e_data
