extends FileDialog

var exporting := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataManager.open_file_dialog.connect(export_review)

func export_review() ->void:
	exporting = true
	title = "Export Review As"
	file_mode = FileDialog.FILE_MODE_SAVE_FILE

func import_review() ->void:
	exporting = false
	title = "Load Review"
	file_mode = FileDialog.FILE_MODE_OPEN_FILE


func _on_file_selected(path: String) -> void:
	if exporting:
		DataManager.save_file(path)
	else:
		DataManager.load_file(path)
