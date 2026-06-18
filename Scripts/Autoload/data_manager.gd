extends Node

const DEFAULT_DATA := preload("res://Scripts/DefaultData.json")
const ELEMENTS_KEY := "Elements"

var data : Dictionary
var quicksave_path := ""

# Opens the quicksave/export popup if no quicksave path exists
signal open_file_dialog()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var json = JSON.new()
	var error = json.parse(JSON.stringify(DEFAULT_DATA.data))
	if error == OK:
		print("Read in default data.")
		print(json.data)
		data = json.data

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Quicksave"):
		print("Quicksaving document")
		if quicksave_path.is_empty():
			open_file_dialog.emit()
		else:
			save_file(quicksave_path)

#region Save & Load
func load_file(path:String) ->void:
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var json = JSON.new()
		var error = json.parse(JSON.stringify(file.data))
		if error == OK:
			print("File read successfully!")
			data = json.data
			quicksave_path = path
		file.close()
	else:
		printerr("File at: " + path + " not found.")

func save_file(path:String) ->void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		# TODO: Store differently for .txt vs .json ?
		file.store_string(JSON.stringify(data, "\t"))
		file.close()
		print("File saved to " + (path) + "successfully!")
	else:
		print("Error: ", FileAccess.get_open_error())
#endregion

func get_element_data(element:ConfigManager.VisualElements) ->Dictionary:
	var e_name : String = ConfigManager.get_element_name(element)
	print('\n\n', element, e_name, data[ELEMENTS_KEY][e_name])
	return data[ELEMENTS_KEY][e_name]

func set_element_data(element:ConfigManager.VisualElements, e_data:Dictionary) ->void:
	data[ELEMENTS_KEY][ConfigManager.get_element_name(element)] = e_data
