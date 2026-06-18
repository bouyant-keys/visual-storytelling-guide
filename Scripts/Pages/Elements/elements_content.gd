extends Control

var current_element := ConfigManager.VisualElements.SPACE
var current_data : Dictionary

@export var intensity_buttons: Array[IntensityToggle]
@export var relationship_buttons: Array[RelationshipToggle]

@onready var element_label: Label = %ElementLabel
@onready var element_description: Label = %ElementDescription
@onready var element_texture: TextureRect = %ElementTexture
@onready var operation_text_edit: TextEdit = %OperationTextEdit
@onready var examples_text_edit: TextEdit = %ExamplesTextEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	operation_text_edit.text_changed.connect(on_operation_changed)
	examples_text_edit.text_changed.connect(on_examples_changed)
	
	for button in intensity_buttons:
		button.intensity_changed.connect(on_intensity_changed)
	
	for button in relationship_buttons:
		button.state_changed.connect(relationship_changed)
	
	# Initialize with first element value:
	current_data = DataManager.get_element_data(current_element)
	on_element_selected(current_element)

func on_element_selected(element:ConfigManager.VisualElements) ->void:
	if element == current_element:
		return
	
	# Save existing data:
	if !current_data.is_empty():
		DataManager.set_element_data(current_element, current_data)
	
	# Load new data:
	current_element = element
	current_data = DataManager.get_element_data(element)
	ConfigManager.current_element = current_element
	
	# Set display elements with loaded data:
	element_label.text = ConfigManager.get_element_name(current_element)
	element_description.text = current_data["Description"] as String
	element_texture.self_modulate = ConfigManager.get_element_color(current_element)
	
	# Set custom values from loaded data:
	set_intensity(current_data["Intensity"] as int)
	operation_text_edit.text = current_data["Operation"] as String
	set_relationships(current_data["Relationships"] as Array)
	examples_text_edit.text = current_data["Examples"] as String

#region Signals
func on_intensity_changed(value:int) ->void:
	current_data["Intensity"] = value
	set_intensity(value)

func on_operation_changed() ->void:
	print("Operation text changed!")
	var op_text = operation_text_edit.text
	current_data["Operation"] = op_text

func relationship_changed(to_element:ConfigManager.VisualElements, state:RelationshipToggle.ToggleState) ->void:
	current_data["Relationship"][to_element] = int(state)

func on_examples_changed() ->void:
	print("Examples text changed!")
	var ex_text = examples_text_edit.text
	current_data["Examples"] = ex_text
#endregion

#region Getters
func get_intensity() ->int:
	var intensity = 0
	
	for i : int in intensity_buttons.size():
		var button := intensity_buttons[i]
		intensity += 1 if button.button_pressed else 0
	
	return intensity

func get_relationships() ->Array[int]:
	var rel_values = [0, 0, 0, 0, 0, 0, 0]
	
	for i : int in relationship_buttons.size():
		var button := relationship_buttons[i]
		if button.button_element == current_element:
			rel_values[i] = 0
			continue
		rel_values[i] = button.button_state
	
	return rel_values
#endregion

#region Setters
func set_intensity(value:int) ->void:
	for i : int in intensity_buttons.size():
		var button := intensity_buttons[i]
		if value > 0:
			button.set_toggle_state(true)
			value -= 1
		else:
			button.set_toggle_state(false)

func set_relationships(rel_values:Array) ->void:
	for i : int in relationship_buttons.size():
		var button := relationship_buttons[i]
		button.set_state(int(rel_values[i]) as RelationshipToggle.ToggleState)
#endregion
