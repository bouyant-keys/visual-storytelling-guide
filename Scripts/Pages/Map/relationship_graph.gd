@tool
extends Panel

var graph_colors := [Color("272d42"), Color("161925")]
var element_colors := [Color("4d83c4"), Color("c9a96e"), Color("9175d4"), 
Color("7ab5c9"), Color("c4574a"), Color("5da06e"), Color("c49c44")]

@export_tool_button("Redraw") var trigger = queue_redraw

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _draw() ->void:
	var center := size/2.0
	var radius := center.x/1.5
	draw_circle(center, radius, graph_colors[1], false, 1.0)
	
	var element_positions : Array[Vector2]
	
	for i in range(7):
		# Rotate from (0, -1) so that there's a dot at the top in the middle
		var dot_pos := Vector2(0.0, -1.0).rotated(i * (TAU/7.0))
		dot_pos = (dot_pos * radius) + center
		element_positions.append(dot_pos)
		draw_circle(dot_pos, 8.0, element_colors[i])
