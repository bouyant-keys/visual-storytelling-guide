class_name DotButton extends TextureButton

const TOOLTIP_FORMAT := "%s - Intensity: %s, Relationships: %d."

var hovered : bool

@export var dot_element : ConfigManager.VisualElements

signal dot_hovered(hovered:bool)
signal dot_selected(dot_element:ConfigManager.VisualElements)

func _ready() ->void:
	pressed.connect(on_dot_pressed)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	focus_entered.connect(on_mouse_entered)
	focus_exited.connect(on_mouse_exited)


func on_dot_pressed() ->void:
	dot_selected.emit(dot_element)

func on_mouse_entered() ->void:
	hovered = true
	dot_hovered.emit(true)

func on_mouse_exited() ->void:
	hovered = false
	dot_hovered.emit(false)

func update_tooltip(e_name:String, e_intensity:int, e_relationships:int) ->void:
	tooltip_text = TOOLTIP_FORMAT % [
		e_name,
		ConfigManager.INTENSITY_VALUES[e_intensity],
		e_relationships
		]
