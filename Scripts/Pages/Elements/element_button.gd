class_name ElementButton extends Button

const TOOLTIP_FORMAT := "Visual Element: %s - Intensity: %s (%d/5)"

@export var element : ConfigManager.VisualElements

@onready var element_label: Label = %ElementLabel
@onready var intensity_bar: ProgressBar = %IntensityBar
@onready var button_dot: TextureRect = %ButtonDot
@onready var selected_bar: Panel = $SelectedBar

signal element_selected(element:ConfigManager.VisualElements)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ConfigManager.palette_changed.connect(_on_palette_changed)
	element_label.text = ConfigManager.get_element_name(element)

func _on_palette_changed() ->void:
	var element_color = ConfigManager.get_element_color(element)
	button_dot.self_modulate = element_color
	intensity_bar.self_modulate = element_color
	selected_bar.self_modulate = element_color

func _on_pressed() -> void:
	selected_bar.visible = button_pressed
	element_selected.emit(element)

func _on_toggled(toggled_on: bool) -> void:
	selected_bar.visible = toggled_on

func update_intensity(value:int) ->void:
	intensity_bar.value = value
	tooltip_text = TOOLTIP_FORMAT % [element_label.text, ConfigManager.INTENSITY_VALUES[value], value]
