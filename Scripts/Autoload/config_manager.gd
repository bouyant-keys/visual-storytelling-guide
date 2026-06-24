extends Node

const DEF_PALETTE_NAME : String = "Custom"
## Ordered: [Primary, Secondary, Tertiary, Quaternary]
const DEF_APP_COLORS : Array[Color] = [Color("0f1118"), Color("161925"), Color("272d42"), Color("4d83c4")]
## Ordered: [Space, Line, Shape, Tone, Color, Movement, Rhythm]
const DEF_ELEMENT_COLORS : Array[Color] = [Color("4d83c4"), Color("c9a96e"), Color("9175d4"), Color("7ab5c9"), Color("c4574a"), Color("5da06e"), Color("c49c44")]
## Ordered: [Neutral, Affinity, Conflict]
const DF_RELATIONSHIP_COLORS : Array[Color] = [Color("FFFFFF"), Color("ae8a3e"), Color("be5448")]
## Ordered: [0, 1, 2, 3, 4, 5]
const INTENSITY_VALUES : Array[String] = ["None", "Minimal", "Subtle", "Moderate", "Strong", "Dominant"]

# Global Structure Data
enum ApplicationColor { PRIMARY, SECONDARY, TERTIARY, QUATERNARY }
enum VisualElements { SPACE, LINE, SHAPE, TONE, COLOR, MOVEMENT, RHYTHM }
enum RelationshipState { NEUTRAL, AFFINITY, CONTRAST }

var current_element : VisualElements

# Palette Data
#TODO: Maybe make into palette data class / resource?
var palette_index : int
var palette_data : Dictionary

var palette_name : String = DEF_PALETTE_NAME
var app_colors : Array[Color] = DEF_APP_COLORS.duplicate()
var element_colors : Array[Color] = DEF_ELEMENT_COLORS.duplicate()
var relationship_colors : Array[Color] = DF_RELATIONSHIP_COLORS.duplicate()

signal palette_changed


func _ready() -> void:
	DataManager.file_loaded.connect(_on_file_loaded)

func _on_file_loaded() ->void:
	set_palette(DataManager.get_last_palette_index())

func reset_palette() ->void:
	palette_index = -1
	palette_name = DEF_PALETTE_NAME
	app_colors = DEF_APP_COLORS.duplicate()
	element_colors = DEF_ELEMENT_COLORS.duplicate()
	relationship_colors = DF_RELATIONSHIP_COLORS.duplicate()
	
	await get_tree().process_frame
	print("-- Palette Changed --")
	palette_changed.emit()

func create_new_palette(p_name:String) ->void:
	var def_palette := DataManager.get_color_data()[0] as Dictionary
	var new_palette := def_palette.duplicate_deep()
	new_palette[DataManager.COL_PALETTE_KEY] = p_name
	DataManager.add_color_data(new_palette)
	set_palette(DataManager.get_color_data().size() - 1)

#region Getters
func get_current_element_color() ->Color:
	return element_colors[int(current_element)]

func get_element_color(element:VisualElements) ->Color:
	return element_colors[int(element)]

func get_relationship_color(relationship:RelationshipState) ->Color:
	return relationship_colors[int(relationship)]

func get_element_colorcode(element:VisualElements) ->String:
	return get_element_color(element).to_html(false)

func get_element_colors() ->Array[Color]:
	return element_colors

func get_element_name(element:VisualElements) ->String:
	return DataManager.E_ELEMENT_KEYS[int(element)]

func get_color_palette_data() ->Dictionary:
	return palette_data
#endregion

func colorcodes_to_colors(colorcodes : Array) ->Array[Color]:
	var colors : Array[Color]
	for code : String in colorcodes:
		colors.append(Color(code))
	return colors
func colors_to_colorcodes(colors : Array) ->Array[String]:
	var colorcodes : Array[String]
	for color : Color in colors:
		colorcodes.append(color.to_html(false))
	return colorcodes

#region Setters
func set_palette(index:int) ->void:
	if index == palette_index:
		return
	elif index == -1:
		reset_palette()
		return
	
	palette_index = index
	palette_data = DataManager.get_palette(palette_index)
	
	palette_name = palette_data[DataManager.COL_PALETTE_KEY]
	app_colors = colorcodes_to_colors(palette_data[DataManager.COL_APP_KEY])
	element_colors = colorcodes_to_colors(palette_data[DataManager.COL_ELEMENT_KEY])
	relationship_colors = colorcodes_to_colors(palette_data[DataManager.COL_RELATIONSHIP_KEY])
	
	await get_tree().process_frame
	print("-- Palette Changed --")
	palette_changed.emit()

func set_palette_name(p_name:String) ->void:
	if palette_index == -1: return
	
	palette_data[DataManager.COL_PALETTE_KEY_KEY] = p_name
	palette_name = p_name

func set_app_color(index:int, color:Color) ->void:
	if palette_index == -1: return
	
	palette_data[DataManager.COL_APP_KEY][index] = color.to_html(false)
	app_colors[index] = color
	palette_changed.emit()

func set_element_color(element:VisualElements, color:Color) ->void:
	if palette_index == -1: return
	
	palette_data[DataManager.COL_ELEMENT_KEY][int(element)] = color.to_html(false)
	element_colors[int(element)] = color
	palette_changed.emit()

func set_relationship_color(index:int, color:Color) ->void:
	if palette_index == -1: return
	
	palette_data[DataManager.COL_RELATIONSHIP_KEY][index] = color.to_html(false)
	relationship_colors[index] = color
	palette_changed.emit()
#endregion
