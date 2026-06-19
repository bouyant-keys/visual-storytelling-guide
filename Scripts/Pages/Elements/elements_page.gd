extends Page

var element_data : Dictionary
var current_element := ConfigManager.VisualElements.SPACE

@export var element_buttons : Array[ElementButton]
@export var intensity_buttons: Array[IntensityToggle]
@export var relationship_buttons: Array[RelationshipToggle]

@onready var element_label: Label = %ElementLabel
@onready var element_description: Label = %ElementDescription
@onready var element_texture: TextureRect = %ElementTexture
@onready var operation_text_edit: TextEdit = %OperationTextEdit
@onready var examples_text_edit: TextEdit = %ExamplesTextEdit

signal element_changed(element:ConfigManager.VisualElements)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataManager.pages.append(self)
	page_key = DataManager.ELEMENTS_KEY
	
	DataManager.file_loaded.connect(on_file_loaded)
	operation_text_edit.text_changed.connect(on_operation_changed)
	examples_text_edit.text_changed.connect(on_examples_changed)
	
	for button : ElementButton in element_buttons:
		button.element_selected.connect(on_element_selected)
		element_changed.connect(button._on_element_selected)
		
		# May cause issues later if grabbed before real data is loaded in???
		var element_intensity = DataManager.get_element_data(button.element)[DataManager.E_INTENSITY_KEY]
		button.update_intensity(element_intensity)
	
	for button : IntensityToggle in intensity_buttons:
		button.intensity_changed.connect(on_intensity_changed)
	
	for button : RelationshipToggle in relationship_buttons:
		button.state_changed.connect(relationship_changed)
	

func on_file_loaded() ->void:
	page_data = DataManager.get_data_by_page_key(page_key)
	element_data = page_data[DataManager.get_visual_element_as_key(current_element)]
	update_display()

func on_element_selected(element:ConfigManager.VisualElements) ->void:
	if element == current_element:
		return
	
	# Save existing data:
	if !element_data.is_empty():
		DataManager.set_element_data(current_element, element_data)
	
	# Load new data:
	current_element = element
	element_data = page_data[DataManager.get_visual_element_as_key(current_element)]
	ConfigManager.current_element = current_element
	update_display()
	
	element_changed.emit(current_element)

func update_display() ->void:
	# Set display elements with loaded data:
	element_label.text = ConfigManager.get_element_name(current_element)
	element_description.text = element_data[DataManager.E_DESCRIPTION_KEY] as String
	element_texture.self_modulate = ConfigManager.get_element_color(current_element)
	
	# Set custom values from loaded data:
	set_intensity(element_data[DataManager.E_INTENSITY_KEY] as int)
	operation_text_edit.text = element_data[DataManager.E_OPERATION_KEY] as String
	set_relationships(element_data[DataManager.E_RELATIONSHIPS_KEY] as Array)
	examples_text_edit.text = element_data[DataManager.E_EXAMPLES_KEY] as String

#region Signals
func on_intensity_changed(value:int) ->void:
	element_data[DataManager.E_INTENSITY_KEY] = value
	set_intensity(value)

func on_operation_changed() ->void:
	var op_text = operation_text_edit.text
	element_data[DataManager.E_OPERATION_KEY] = op_text

func relationship_changed(to_element:ConfigManager.VisualElements, state:RelationshipToggle.ToggleState) ->void:
	element_data[DataManager.E_RELATIONSHIPS_KEY][to_element] = int(state)

func on_examples_changed() ->void:
	var ex_text = examples_text_edit.text
	element_data[DataManager.E_EXAMPLES_KEY] = ex_text
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
	var temp := value
	for i : int in intensity_buttons.size():
		var button := intensity_buttons[i]
		if temp > 0:
			button.set_toggle_state(true)
			temp -= 1
		else:
			button.set_toggle_state(false)
	
	for button : ElementButton in element_buttons:
		if button.element == current_element:
			button.update_intensity(value)

func set_relationships(rel_values:Array) ->void:
	for i : int in relationship_buttons.size():
		var button := relationship_buttons[i]
		button.set_state(int(rel_values[i]) as RelationshipToggle.ToggleState)
#endregion
