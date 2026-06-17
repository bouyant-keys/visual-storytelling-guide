extends Button

@export var element : ConfigManager.VisualElements
@export var element_name : String

@onready var dot: TextureRect = $Dot
@onready var label: Label = $Dot/Label
@onready var progress_bar: ProgressBar = $Dot/ProgressBar

signal element_selected(element:ConfigManager.VisualElements)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = element_name
	
	var element_color = ConfigManager.get_element_color(element)
	dot.self_modulate = element_color
	progress_bar.add_theme_color_override("bg_color", element_color)
	#var fill_sbox = progress_bar.get_theme_stylebox("fill")
	#fill_sbox.
	#progress_bar.add_theme_stylebox_override("fill", fill_sbox)


func _on_button_down() -> void:
	element_selected.emit(element)

func _on_button_up() -> void:
	pass # Replace with function body.

func _on_highlight_enter() -> void:
	pass # Replace with function body.

func _on_highlight_exited() -> void:
	pass # Replace with function body.
