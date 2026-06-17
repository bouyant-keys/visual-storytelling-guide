extends Control

@onready var elements_page: Page = $ElementsPage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_tab_changed(tab: int) -> void:
	print("Tab:", tab, "pressed.")
	
	match(tab):
		0:
			elements_page.set_active()
		1:
			pass
		2:
			pass
		3:
			pass
