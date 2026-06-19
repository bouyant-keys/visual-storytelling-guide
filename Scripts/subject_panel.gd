extends Page

@onready var title_edit: LineEdit = %TitleEdit
@onready var type_dropdown: OptionButton = %TypeDropdown
@onready var creator_edit: LineEdit = %CreatorEdit
@onready var year_edit: LineEdit = %YearEdit
@onready var synopsis_edit: LineEdit = %SynopsisEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataManager.pages.append(self)
	page_key = DataManager.SUBJECT_KEY
	
	DataManager.file_loaded.connect(on_file_loaded)
	title_edit.text_changed.connect(on_title_changed)
	type_dropdown.item_selected.connect(on_type_selected)
	creator_edit.text_changed.connect(on_creator_changed)
	year_edit.text_changed.connect(on_year_changed)
	synopsis_edit.text_changed.connect(on_synopsis_changed)

func on_file_loaded() ->void:
	page_data = DataManager.get_data_by_page_key(page_key)
	
	title_edit.text = page_data[DataManager.S_TITLE_KEY]
	type_dropdown.selected = page_data[DataManager.S_TYPE_KEY]
	creator_edit.text = page_data[DataManager.S_CREATOR_KEY]
	year_edit.text = page_data[DataManager.S_YEAR_KEY]
	synopsis_edit.text = page_data[DataManager.S_SYNOPSIS_KEY]

#region Property Signals
func on_title_changed(text:String) ->void:
	page_data[DataManager.S_TITLE_KEY] = text

func on_type_selected(value:int) ->void:
	page_data[DataManager.S_TYPE_KEY] = value

func on_creator_changed(text:String) ->void:
	page_data[DataManager.S_CREATOR_KEY] = text

func on_year_changed(text:String) ->void:
	page_data[DataManager.S_YEAR_KEY] = text

func on_synopsis_changed(text:String) ->void:
	page_data[DataManager.S_SYNOPSIS_KEY] = text
#endregion
