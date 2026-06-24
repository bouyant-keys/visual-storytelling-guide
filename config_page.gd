extends Page

@onready var palete_option_button: OptionButton = %PaleteOptionButton
@onready var new_palette_line_edit: LineEdit = %NewPaletteLineEdit
@onready var new_palette_button: Button = %NewPaletteButton
@onready var app_v_box: VBoxContainer = %AppVBox
@onready var element_v_box: VBoxContainer = %ElementVBox
@onready var relationship_v_box: VBoxContainer = %RelationshipVBox
@onready var credits_panel: PanelContainer = %CreditsPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ConfigManager.palette_changed.connect(_on_palette_changed)
	_on_palette_item_selected(0)
	credits_panel.hide()

func _on_palette_changed() ->void:
	palete_option_button.select(ConfigManager.palette_index+1)

func _on_palette_item_selected(index:int) ->void:
	# Default = 0, which should be -1
	ConfigManager.set_palette(index-1)
	if index == 0:
		element_v_box.hide()
		relationship_v_box.hide()
	else:
		element_v_box.show()
		relationship_v_box.show()
	
	DataManager.unsaved_changes.emit()

func on_new_palette_pressed() ->void:
	ConfigManager.create_new_palette(new_palette_line_edit.text)
	DataManager.unsaved_changes.emit()

func _on_credits_pressed() ->void:
	credits_panel.show()

func _on_close_credits_pressed() ->void:
	credits_panel.hide()
