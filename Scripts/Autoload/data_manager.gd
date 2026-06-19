extends Node

const DEFAULT_DATA := preload("res://Scripts/DefaultData.json")

const SUBJECT_KEY := "Subject"
const S_TITLE_KEY := "Title"
const S_TYPE_KEY := "Type"
const S_CREATOR_KEY := "Creator"
const S_YEAR_KEY := "Year"
const S_SYNOPSIS_KEY := "Synopsis"

const ELEMENTS_KEY := "Elements"
const E_ELEMENT_KEYS := ["Space", "Line", "Shape", "Tone", "Color", "Movement", "Rhythm"]
const E_DESCRIPTION_KEY := "Description"
const E_INTENSITY_KEY := "Intensity"
const E_RELATIONSHIPS_KEY := "Relationships"
const E_OPERATION_KEY := "Operation"
const E_EXAMPLES_KEY := "Examples"

const SYNTHESIS_KEY = "Synthesis"
const SY_STRATEGY_KEY = "Strategy"
const SY_ANGLE_KEY = "Angle"

var data : Dictionary
var pages : Array[Page]
var quicksave_path := ""

# Opens the quicksave/export popup if no quicksave path exists
signal open_file_dialog
signal file_loaded
signal file_saved

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var json = JSON.new()
	var error = json.parse(JSON.stringify(DEFAULT_DATA.data))
	if error == OK:
		print("Read in default data.")
		print(json.data)
		data = json.data
		
		# Deferred in case of mishaps
		await get_tree().process_frame
		file_loaded.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Quicksave"):
		print("Quicksaving document")
		if quicksave_path.is_empty():
			open_file_dialog.emit()
		else:
			save_file(quicksave_path)
	elif event.is_action_pressed("PrintData"):
		print("Printing data: \n", data)

#region Save & Load
func load_file(path:String) ->void:
	# Load default file to merge onto -- assuming missing keys
	var def_data : Dictionary
	var json = JSON.new()
	var error = json.parse(JSON.stringify(DEFAULT_DATA.data))
	if error == OK:
		print("Read in default data.")
		def_data = json.data
		print('\n\n',def_data)
	
	var file_data : Dictionary
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		json = JSON.new()
		error = json.parse(file.get_as_text())
		if error == OK:
			print("File read successfully!")
			file_data = json.data
			print('\n\n', file_data)
			quicksave_path = path
		file.close()
	else:
		printerr("File at: " + path + " not found.")
	
	# Merge Dictionaries:
	data = deep_merge(def_data, file_data)
	file_loaded.emit()

# Function Source: https://tajammalmaqbool.com/blogs/godot-dictionary-a-comprehensive-guide
func deep_merge(a: Dictionary, b: Dictionary) -> Dictionary:
	var out = a.duplicate(true)
	for k in b:
		if out.has(k) and out[k] is Dictionary and b[k] is Dictionary:
			out[k] = deep_merge(out[k], b[k])
		else:
			out[k] = b[k]
	return out

func save_file(path:String) ->void:
	# Gather data from pages into main data object
	for page : Page in pages:
		data[page.get_page_key()] = page.get_page_data()
	
	# Convert data into file & save to path
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		# TODO: Store differently for .txt vs .json ?
		file.store_string(JSON.stringify(data, "\t"))
		file.close()
		quicksave_path = path
		file_saved.emit()
		print("File saved to " + (path) + " successfully!")
	else:
		print("Error: ", FileAccess.get_open_error())
#endregion

#region Getters
func get_data_by_page_key(page_key:String) ->Dictionary:
	return data[page_key]

func get_visual_element_as_key(element:ConfigManager.VisualElements) ->String:
	return E_ELEMENT_KEYS[int(element)]

func get_element_data(element:ConfigManager.VisualElements) ->Dictionary:
	var e_name : String = ConfigManager.get_element_name(element)
	print('\n\n', element, e_name, data[ELEMENTS_KEY][e_name])
	return data[ELEMENTS_KEY][e_name]
#endregion

func set_element_data(element:ConfigManager.VisualElements, e_data:Dictionary) ->void:
	data[ELEMENTS_KEY][ConfigManager.get_element_name(element)] = e_data
