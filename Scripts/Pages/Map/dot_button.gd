class_name DotButton extends TextureButton

const TOOLTIP_FORMAT := "%s - Intensity: %s, Relationships: %d"

var hovered : bool

@export var dot_element : ConfigManager.VisualElements

@onready var highlight_texture: TextureRect = $HighlightTexture

signal dot_hovered(hovered:bool)
signal dot_selected(dot_element:ConfigManager.VisualElements)

func _ready() ->void:
	highlight_texture.hide()

func _on_dot_down() -> void:
	highlight_texture.self_modulate = Color.GRAY

func on_dot_pressed() ->void:
	dot_selected.emit(dot_element)

func on_mouse_entered() ->void:
	hovered = true
	highlight_texture.self_modulate = Color.WHITE
	highlight_texture.show()
	dot_hovered.emit(true)

func on_mouse_exited() ->void:
	hovered = false
	highlight_texture.hide()
	dot_hovered.emit(false)

func update_tooltip(e_relationships:int) ->void:
	tooltip_text = TOOLTIP_FORMAT % [
		ConfigManager.get_element_name(dot_element),
		ConfigManager.INTENSITY_VALUES[DataManager.get_element_intensities()[int(dot_element)]],
		e_relationships
		]
