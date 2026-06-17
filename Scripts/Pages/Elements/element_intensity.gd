extends Control

@export var intensity_buttons: Array[Button]

func on_element_selected(element_name:String, element_data:Dictionary) ->void:
	set_intensity(element_data[element_name]["Intensity"])

func set_intensity(value:int) ->void:
	for i in range(value):
		print(i)
		intensity_buttons[i].button_pressed = true
		

func on_one_intensity_pressed() ->void: set_intensity(1)
func on_two_intensity_pressed() ->void: set_intensity(2)
func on_three_intensity_pressed() ->void: set_intensity(3)
func on_four_intensity_pressed() ->void: set_intensity(4)
func on_fve_intensity_pressed() ->void: set_intensity(5)
