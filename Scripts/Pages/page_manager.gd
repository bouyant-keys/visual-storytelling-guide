extends Control

var current_page := -1

@onready var elements_page: Panel = %ElementsPage
@onready var map_page: Panel = %MapPage
@onready var synthesis_page: Panel = %SynthesisPage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_tab_changed(0)

func _on_tab_changed(tab: int) -> void:
	print("Tab: ", tab, " pressed.")
	
	if tab == current_page:
		return
	
	elements_page.hide()
	map_page.hide()
	synthesis_page.hide()
	
	match(tab):
		0:
			elements_page.show()
		1:
			map_page.show()
		2:
			synthesis_page.show()
