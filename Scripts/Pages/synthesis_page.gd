extends Page

@onready var strategy_text_edit: TextEdit = %StrategyTextEdit
@onready var angle_text_edit: TextEdit = %AngleTextEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataManager.pages.append(self)
	page_key = DataManager.SYNTHESIS_KEY
	DataManager.file_loaded.connect(on_file_loaded)
	
	strategy_text_edit.text_changed.connect(on_strategy_changed)
	angle_text_edit.text_changed.connect(on_angle_changed)

func on_file_loaded() ->void:
	page_data = DataManager.get_data_by_page_key(page_key)
	strategy_text_edit.text = page_data[DataManager.SY_STRATEGY_KEY]
	angle_text_edit.text = page_data[DataManager.SY_ANGLE_KEY]
	

func on_strategy_changed() ->void:
	page_data[DataManager.SY_STRATEGY_KEY] = strategy_text_edit.text

func on_angle_changed() ->void:
	page_data[DataManager.SY_ANGLE_KEY] = angle_text_edit.text
