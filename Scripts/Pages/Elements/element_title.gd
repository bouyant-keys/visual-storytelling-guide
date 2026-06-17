extends Control

@onready var element_texture: TextureRect = $ElementTexture
@onready var element_label: Label = $ElementLabel
@onready var element_description: Label = $ElementLabel/ElementDescription

func on_element_selected(element_name:String, element_data:Dictionary) ->void:
	#e_name = element_data['Name']
	#e_color = PaletteManager.get_element_color()
	
	#element_texture.self_modulate = 
	element_label.text = element_data['Name']
	element_description.text = element_data['Description']
