extends Node

const DEFAULT_DATA := preload("res://Scripts/DefaultData.json")

const PROJECT_KEY := "Project"
const P_AUTHOR_KEY := "Author"
const P_CREATION_KEY := "CreationDate"
const P_PALETTEINDEX := "PaletteIndex"
const P_CUSTOMCOLORS_KEY := "CustomColors"
const COL_PALETTE_KEY := "Palette"
const COL_APP_KEY := "AppColors"
const COL_ELEMENT_KEY := "ElementColors:"
const COL_RELATIONSHIP_KEY := "RelationshipColors"

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

const MAP_KEY := "Map"
const M_RELATIONSHIPS_KEY := "Relationships"

const SYNTHESIS_KEY = "Synthesis"
const SY_STRATEGY_KEY = "Strategy"
const SY_ANGLE_KEY = "Angle"

var data : Dictionary
var pages : Array[Page]
var graph_page : Page
var quicksave_path := ""
## Quits the application after saving is completed
var queue_quit := false

# Opens the quicksave/export popup if no quicksave path exists
signal save_file_dialog
signal load_file_dialog
signal file_loaded
signal file_saved
signal unsaved_changes
signal quit_dialog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().auto_accept_quit = false
	
	var json = JSON.new()
	var error = json.parse(JSON.stringify(DEFAULT_DATA.data))
	if error == OK:
		print("Read in default data.")
		data = json.data
		
		# Deferred in case of mishaps
		await get_tree().process_frame
		file_loaded.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Quicksave"):
		print("Quicksaving document")
		if quicksave_path.is_empty():
			save_file_dialog.emit()
		else:
			save_file(quicksave_path)
	elif event.is_action_pressed("PrintData"):
		print("Printing data: \n", data)

# Source: https://forum.godotengine.org/t/best-ways-to-save-on-quit/40825/3
func _notification(notif: int) -> void:
	if notif == NOTIFICATION_WM_CLOSE_REQUEST:
		quit_dialog.emit()

func quit() ->void:
	get_tree().quit()

#region Save & Load
func load_file(path:String) ->void:
	# Load default file to merge onto -- assuming missing keys
	var def_data : Dictionary
	var json = JSON.new()
	var error = json.parse(JSON.stringify(DEFAULT_DATA.data))
	if error == OK:
		print("Read in default data.")
		def_data = json.data
	
	var file_data : Dictionary
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		json = JSON.new()
		error = json.parse(file.get_as_text())
		if error == OK:
			print("File read successfully!")
			file_data = json.data
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
	
	# Save Color info
	# Restricting to only 1 palette -- maybe implement more in future.
	var palette_data := ConfigManager.get_color_palette_data()
	print(palette_data)
	data[PROJECT_KEY][P_CUSTOMCOLORS_KEY][0] = palette_data
	
	print("Save Data:\n", data)
	
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
	
	if queue_quit:
		get_tree().quit()

func save_graph(path:String) ->void:
	# Get Image from map
	var graph_data := graph_page.get_page_data()
	var image := graph_data[graph_page.get_page_key()] as Image
	
	if !image:
		printerr("No graph image to export!")
	
	var error:Error
	if path.contains(".png"):
		error = image.save_png(path)
	else:
		error = image.save_jpg(path)
	
	if error:
		print("Error: ", error)
	else:
		print("Graph saved to " + (path) + " successfully!")

func quicksave() ->void:
	save_file(quicksave_path)

func file_dialog_canceled() ->void:
	if queue_quit:
		get_tree().quit()

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

func get_element_intensities() ->Array[int]:
	var intensities : Array[int]
	for key : String in E_ELEMENT_KEYS:
		intensities.append(int(data[ELEMENTS_KEY][key][E_INTENSITY_KEY]))
	return intensities

func get_relationship(x:int, y:int) ->int:
	return data[MAP_KEY][M_RELATIONSHIPS_KEY][x][y]

func get_element_relationships(e:ConfigManager.VisualElements) ->Array[int]:
	var e_relationships : Array[int] 
	e_relationships.assign(data[MAP_KEY][M_RELATIONSHIPS_KEY][int(e)])
	return e_relationships

func get_all_relationships() ->Array:
	return data[MAP_KEY][M_RELATIONSHIPS_KEY]

func get_last_palette_index() ->int:
	return int(data[PROJECT_KEY][P_PALETTEINDEX])

func get_palette(palette_index:int) ->Dictionary:
	return data[PROJECT_KEY][P_CUSTOMCOLORS_KEY][palette_index]

## Returns array of all color palettes.
func get_color_data() ->Array:
	return data[PROJECT_KEY][P_CUSTOMCOLORS_KEY]

#endregion

#region Setters
func set_element_data(element:ConfigManager.VisualElements, e_data:Dictionary) ->void:
	data[ELEMENTS_KEY][ConfigManager.get_element_name(element)] = e_data

func set_relationship_data(x:int, y:int, value:int, undirected:bool=true) ->void:
	data[MAP_KEY][M_RELATIONSHIPS_KEY][x][y] = value
	if undirected:
		data[MAP_KEY][M_RELATIONSHIPS_KEY][y][x] = value

func add_color_data(palette:Dictionary) ->void:
	data[PROJECT_KEY][P_CUSTOMCOLORS_KEY].append(palette)
#endregion
