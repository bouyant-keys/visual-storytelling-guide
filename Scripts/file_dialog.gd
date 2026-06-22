class_name FilePopup extends FileDialog

const file_export_filters : PackedStringArray = ["*.txt", "*.json", "*.JSON"]
const graph_export_filters : PackedStringArray = ["*.png", "*.jpg"]

enum FileAccessType {EXPORT_FILE, EXPORT_GRAPH, IMPORT_FILE}
var current_file_access : FileAccessType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataManager.save_file_dialog.connect(export_review)
	canceled.connect(DataManager.file_dialog_canceled)

func export_graph() ->void:
	current_file_access = FileAccessType.EXPORT_GRAPH
	title = "Export Graph As"
	file_mode = FileDialog.FILE_MODE_SAVE_FILE
	filters = graph_export_filters
	popup_file_dialog()

func export_review() ->void:
	current_file_access = FileAccessType.EXPORT_FILE
	title = "Export Review As"
	file_mode = FileDialog.FILE_MODE_SAVE_FILE
	filters = file_export_filters
	popup_file_dialog()

func import_review() ->void:
	current_file_access = FileAccessType.IMPORT_FILE
	title = "Load Review"
	file_mode = FileDialog.FILE_MODE_OPEN_FILE
	popup_file_dialog()


func _on_file_selected(path: String) -> void:
	match(current_file_access):
		FileAccessType.EXPORT_FILE:
			DataManager.save_file(path)
		FileAccessType.EXPORT_GRAPH:
			DataManager.save_graph(path)
		FileAccessType.IMPORT_FILE:
			DataManager.load_file(path)
