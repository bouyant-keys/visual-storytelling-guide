class_name ElementButton extends Button

@export var element : ConfigManager.VisualElements

@onready var element_label: Label = %ElementLabel
@onready var intensity_bar: ProgressBar = %IntensityBar
@onready var button_dot: TextureRect = %ButtonDot

signal element_selected(element:ConfigManager.VisualElements)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ConfigManager.palette_changed.connect(_on_palette_changed)
	element_label.text =  ConfigManager.get_element_name(element)
	

func _on_palette_changed() ->void:
	var element_color = ConfigManager.get_element_color(element)
	button_dot.self_modulate = element_color
	intensity_bar.self_modulate = element_color

func _on_button_down() -> void:
	element_selected.emit(element)

func _on_element_selected(selected_element:ConfigManager.VisualElements) ->void:
	if selected_element != element:
		set_pressed_no_signal(false)

func update_intensity(value:int) ->void:
	print("Button intensity updating: ", value)
	intensity_bar.value = value
