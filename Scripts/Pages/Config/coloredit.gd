extends PanelContainer

const PROPERTY_FORMAT := " %s "

var color_index : int

@export var property_name : String
@export var app_color_index := -1
@export var element_color_index := -1
@export var relationship_color_index := -1

@onready var property_label: Label = %PropertyLabel
@onready var color_picker: ColorPickerButton = %ColorPicker

signal color_changed(color:Color)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ConfigManager.palette_changed.connect(_on_palette_changed)
	
	property_label.text = PROPERTY_FORMAT % property_name
	if app_color_index > -1:
		color_index = app_color_index
		color_picker.color = ConfigManager.app_colors[color_index]
		color_changed.connect(ConfigManager.set_app_color)
	elif element_color_index > -1:
		color_index = element_color_index
		color_picker.color = ConfigManager.element_colors[color_index]
		color_changed.connect(ConfigManager.set_element_color)
	elif relationship_color_index > -1:
		color_index = relationship_color_index
		color_picker.color = ConfigManager.relationship_colors[color_index]
		color_changed.connect(ConfigManager.set_relationship_color)
	else:
		printerr("ColorEdit not set to app, element, or relationship indexes.")

func _on_palette_changed() ->void:
	if app_color_index > -1:
		color_picker.color = ConfigManager.app_colors[color_index]
	elif element_color_index > -1:
		color_picker.color = ConfigManager.element_colors[color_index]
	elif relationship_color_index > -1:
		print("ColorPicker on_palette_changed()!")
		color_picker.color = ConfigManager.relationship_colors[color_index]

func _on_color_changed(color: Color) -> void:
	color_changed.emit(color_index, color)
