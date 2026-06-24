extends AcceptDialog

const UNSAVED_TEXT := "You may have unsaved changes. Do you want to save before quitting? (Unsaved changes will be lost.)"
const QUIT_ACTION := "Quit"

var queue_quit := false

signal save_file_dialog

func _ready() -> void:
	DataManager.quit_dialog.connect(_on_quit)
	DataManager.file_saved.connect(_on_file_saved)
	add_button("Quit", true, QUIT_ACTION)
	add_cancel_button("Cancel")

func _on_quit() ->void:
	popup_centered_clamped()

func _on_confirmed() -> void:
	queue_quit = true
	if DataManager.quicksave_path.is_empty():
		save_file_dialog.emit()
	else:
		DataManager.quicksave()

func _on_custom_action(action: StringName) -> void:
	if action == QUIT_ACTION:
		get_tree().quit()

func _on_file_saved() ->void:
	if queue_quit:
		get_tree().quit()
