extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ConfigManager.palette_changed.connect(on_palette_changed)
	DataManager.unsaved_changes.connect(on_unsaved_changes)
	DataManager.file_saved.connect(on_file_saved)

func on_palette_changed() ->void:
	self_modulate = ConfigManager.app_colors[3]

func on_unsaved_changes() ->void:
	show()

func on_file_saved() ->void:
	hide()
