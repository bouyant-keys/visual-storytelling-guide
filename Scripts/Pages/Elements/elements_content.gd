extends Control

@export var intensity_buttons: Array[Button]
@export var relationship_buttons: Array[Button]

@onready var element_label: Label = %ElementLabel
@onready var element_description: Label = %ElementDescription
@onready var element_texture: TextureRect = %ElementTexture

@onready var operation_text_edit: TextEdit = %OperationTextEdit
@onready var examples_text_edit: TextEdit = %ExamplesTextEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func on_element_selected(element:ConfigManager.VisualElements) ->void:
	var e_data := DataManager.get_elements_data()
	var e_name := ConfigManager.get_element_name(element)
	
	var element_data = e_data[e_name]
	
	
	element_label.text = e_name
	element_description.text = element_data["Description"]
	#element_texture.self_modulate = ConfigManager.get_element_color(e_name)
	var operations_data : String = element_data["Operation"]
	var examples_data : String = element_data["Examples"]
	
	#if operations_data.is_empty():
	

func relationship_changed(element:ConfigManager.VisualElements, relationship:int):
	print(relationship)
	
	#var e_data := DataManager.get_elements_data()
	#DataManager.set_elements_data(e_data)
