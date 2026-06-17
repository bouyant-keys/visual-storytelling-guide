extends Node

# Global Structure Data
enum VisualElements {SPACE, LINE, SHAPE, TONE, COLOR, MOVEMENT, RHYTHM}

# Palette Data
const ELEMENT_SPACE_COLOR := Color("4d83c4")
const ELEMENT_LINE_COLOR := Color("c9a96e")
const ELEMENT_SHAPE_COLOR := Color("9175d4")
const ELEMENT_TONE_COLOR := Color("7ab5c9")
const ELEMENT_COLOR_COLOR := Color("c4574a")
const ELEMENT_MOVEMENT_COLOR := Color("5da06e")
const ELEMENT_RHYTHM_COLOR := Color("c49c44")

func get_element_color(element:VisualElements) ->Color:
	var e_color := ELEMENT_SPACE_COLOR
	
	match(element):
		VisualElements.LINE:
			e_color = ELEMENT_LINE_COLOR
		VisualElements.SHAPE:
			e_color = ELEMENT_SHAPE_COLOR
		VisualElements.TONE:
			e_color = ELEMENT_TONE_COLOR
		VisualElements.COLOR:
			e_color = ELEMENT_COLOR_COLOR
		VisualElements.MOVEMENT:
			e_color = ELEMENT_MOVEMENT_COLOR
		VisualElements.RHYTHM:
			e_color = ELEMENT_RHYTHM_COLOR
	
	return e_color
func get_element_name(element:VisualElements) ->String:
	var e_name := "Space"
	
	match(element):
		VisualElements.LINE:
			e_name = "Line"
		VisualElements.SHAPE:
			e_name = "Shape"
		VisualElements.TONE:
			e_name = "Tone"
		VisualElements.COLOR:
			e_name = "Color"
		VisualElements.MOVEMENT:
			e_name = "Movement"
		VisualElements.RHYTHM:
			e_name = "Rhythm"
	
	return e_name
