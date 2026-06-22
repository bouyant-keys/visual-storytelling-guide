extends Control

var current_page := -1

@onready var pages := [%ElementsPage, %MapPage, %SynthesisPage, %ConfigPage]
@onready var tab_bar: TabBar = %TabBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_tab_changed(0)

func switch_page(to_page:Page) ->void:
	for i : int in pages.size():
		var page = pages[i]
		if page == to_page:
			tab_bar.current_tab = i # Switches the page

func _on_tab_changed(tab: int) -> void:
	if tab == current_page:
		return
	
	for i : int in pages.size():
		if i == tab:
			pages[i].show()
		else:
			pages[i].hide()
