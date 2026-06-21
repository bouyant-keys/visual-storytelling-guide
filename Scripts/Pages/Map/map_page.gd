extends Page

const DEFAULT_RESOLUTION := Vector2i(512, 512)

var export_image : Image

@onready var capture_viewport: SubViewport = %CaptureViewport
@onready var export_panel: PanelContainer = %ExportPanel
@onready var x_res_edit: SpinBox = %XResEdit
@onready var y_res_edit: SpinBox = %YResEdit
@onready var export_button: Button = %ExportButton
@onready var graph_parent: Control = %GraphParent

signal export_graph_to

func _ready() ->void:
	DataManager.graph_page = self
	page_key = DataManager.MAP_KEY
	
	export_panel.hide()

func get_page_data() ->Dictionary:
	return {page_key:export_image}

func update_graph() ->void:
	for child : Control in graph_parent.get_children():
		child.queue_redraw()

func _on_save_pressed() ->void:
	export_panel.show()
	update_graph()

func _on_export_pressed() ->void:
	# Only render viewport for capture
	export_image = capture_viewport.get_texture().get_image()
	export_graph_to.emit()

func _on_cancel_pressed() ->void:
	export_panel.hide()

func _on_resolution_changed(_value:float) -> void:
	var resolution := Vector2i(int(x_res_edit.value), int(y_res_edit.value))
	capture_viewport.size = resolution
	print("New Resolution: ", capture_viewport.size)
	update_graph()

func _on_resolution_reset() ->void:
	capture_viewport.size = DEFAULT_RESOLUTION
