extends Page

@onready var palete_option_button: OptionButton = %PaleteOptionButton
@onready var new_palette_line_edit: LineEdit = %NewPaletteLineEdit
@onready var new_palette_button: Button = %NewPaletteButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataManager.file_loaded.connect(update_palette_options)
	ConfigManager.palette_changed.connect(update_palette_options)

func update_palette_options() ->void:
	print("Updating palette options!")
	palete_option_button.clear()
	for palette:Dictionary in DataManager.get_color_data():
		palete_option_button.add_item(palette[DataManager.COL_PALETTE_KEY])
	palete_option_button.select(ConfigManager.current_palette)

func _on_palette_item_selected(index:int) ->void:
	ConfigManager.set_palette(index)
	DataManager.unsaved_changes.emit()

func on_new_palette_pressed() ->void:
	ConfigManager.create_new_palette(new_palette_line_edit.text)
	DataManager.unsaved_changes.emit()
