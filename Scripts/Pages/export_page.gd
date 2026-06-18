extends Page

@onready var file_dialog: FileDialog = $FileDialog

func _on_export_button_pressed() -> void:
	file_dialog.current_path = "user://"
	file_dialog.popup_file_dialog()

func _on_file_dialog_confirmed() -> void:
	print("saving...")
	pass # Replace with function body.

func _on_file_dialog_canceled() -> void:
	print("save canceled.")
	pass # Replace with function body.


func _on_file_dialog_file_selected(path: String) -> void:
	print("File selected: " + path)
	DataManager.save_file(path)
