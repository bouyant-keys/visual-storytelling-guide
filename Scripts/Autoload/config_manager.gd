extends Node

const INTENSITY_VALUES : Array[String] = ["None", "Minimal", "Subtle", "Moderate", "Strong", "Dominant"]

# Global Structure Data
enum VisualElements {SPACE, LINE, SHAPE, TONE, COLOR, MOVEMENT, RHYTHM}
var current_element : VisualElements

# Palette Data
var current_palette : int
var palette_data : Dictionary

var palette_name : String = "Default"
## Ordered: [Primary, Secondary, Tertiary, Quaternary]
var app_colors : Array[Color] = [Color("0f1118"), Color("161925"), Color("272d42"), Color("4d83c4")]
## Ordered: [Space, Line, Shape, Tone, Color, Movement, Rhythm]
var element_colors : Array[Color] = [Color("4d83c4"), Color("c9a96e"), Color("9175d4"), Color("7ab5c9"), Color("c4574a"), Color("5da06e"), Color("c49c44")]
## Ordered: [Affinity, Conflict, Neutral]
var relationship_colors : Array[Color] = [Color("ae8a3e"), Color("be5448"), Color("272d42")]

signal palette_changed


func _ready() -> void:
	DataManager.file_loaded.connect(on_file_loaded)

func on_file_loaded() ->void:
	set_palette(DataManager.get_color_palette())

#region Getters
func get_current_element_color() ->Color:
	return element_colors[int(current_element)]

func get_element_color(element:VisualElements) ->Color:
	return element_colors[int(element)]

func get_element_colorcode(element:VisualElements) ->String:
	return get_element_color(element).to_html(false)

func get_element_colors() ->Array[Color]:
	return element_colors

func get_element_name(element:VisualElements) ->String:
	return DataManager.E_ELEMENT_KEYS[int(element)]

func get_color_palette_data() ->Dictionary:
	for i : int in palette_data[DataManager.COL_APP_KEY].size():
		palette_data[DataManager.COL_APP_KEY][i] = app_colors[i].to_html(false)
	for i : int in palette_data[DataManager.COL_ELEMENT_KEY].size():
		palette_data[DataManager.COL_ELEMENT_KEY][i] = element_colors[i].to_html(false)
	for i : int in palette_data[DataManager.COL_RELATIONSHIP_KEY].size():
		palette_data[DataManager.COL_RELATIONSHIP_KEY][i] = relationship_colors[i].to_html(false)
	return palette_data
#endregion

#region Setters
func set_palette(index:int) ->void:
	current_palette = index
	palette_data = DataManager.get_color_data()[current_palette]
	
	palette_name = palette_data[DataManager.COL_PALETTE_KEY]
	for value : String in palette_data[DataManager.COL_APP_KEY]:
		app_colors.append(Color(value))
	for value : String in palette_data[DataManager.COL_ELEMENT_KEY]:
		element_colors.append(Color(value))
	for value : String in palette_data[DataManager.COL_RELATIONSHIP_KEY]:
		relationship_colors.append(Color(value))
	
	await get_tree().process_frame
	palette_changed.emit()

func create_new_palette(p_name:String) ->void:
	var def_palette := DataManager.get_color_data()[0] as Dictionary
	var new_palette := def_palette.duplicate_deep()
	new_palette[DataManager.COL_PALETTE_KEY] = p_name
	DataManager.add_color_data(new_palette)
	set_palette(DataManager.get_color_data().size() - 1)

func set_palette_name(p_name:String) ->void:
	palette_name = p_name

func set_app_color(index:int, color:Color) ->void:
	app_colors[index] = color
	palette_changed.emit()

func set_element_color(element:VisualElements, color:Color) ->void:
	element_colors[int(element)] = color
	palette_changed.emit()

func set_relationship_color(index:int, color:Color) ->void:
	relationship_colors[index] = color
	palette_changed.emit()
#endregion
