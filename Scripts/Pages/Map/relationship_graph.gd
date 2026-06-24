extends Graph

const KEY_FORMAT := "[color=#%s][s]  [/s][/color] Affinity  [color=#%s][s] [/s] [s] [/s][/color] Contrast  Size=Intensity"
const LEGEND_FORMAT := "[color=#%s]•[/color] %s\n"
const DOT_TOOLTIP_FORMAT := "Shape - Intensity: %s, Relationships: %d"

var highlighted_dot := -1
var element_dots : Array[DotButton]
var graph_colors := [Color("272d42"), Color("161925")]

#@export_tool_button("Redraw") var trigger = queue_redraw

## Graph center is based on the panel's size.
@export var graph_center := Vector2(0.4, 0.5)
## Graph radius is based on the panel's x-length.
@export var graph_radius := 0.7
## dot_radius = ratio * central graph radius
@export var dot_radius_ratios := [0.1, 0.1, 0.2, 0.3, 0.4, 0.5]

@onready var dot_parent: Control = %Dots
@onready var key_label: RichTextLabel = %KeyLabel
@onready var legend_label: RichTextLabel = %LegendLabel

signal dot_selected(element:ConfigManager.VisualElements)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataManager.file_loaded.connect(queue_redraw)
	ConfigManager.palette_changed.connect(_on_palette_changed)
	legend_label.clear()
	
	for dot : DotButton in dot_parent.get_children():
		dot.dot_selected.connect(_on_dot_selected)
		dot.dot_hovered.connect(_on_dot_hovered)
		element_dots.append(dot)

func _on_palette_changed() ->void:
	legend_label.clear()
	
	for dot : DotButton in dot_parent.get_children():
		var dot_label := LEGEND_FORMAT % [
			ConfigManager.get_element_colorcode(dot.dot_element),
			DataManager.E_ELEMENT_KEYS[dot.dot_element]]
		legend_label.append_text(dot_label)
	
	key_label.text = KEY_FORMAT % [
		ConfigManager.get_relationship_color(ConfigManager.RelationshipState.AFFINITY).to_html(false),
		ConfigManager.get_relationship_color(ConfigManager.RelationshipState.CONTRAST).to_html(false)]
	
	queue_redraw()

func _on_dot_hovered(hovering:bool) ->void:
	if !hovering:
		highlighted_dot = -1
		queue_redraw()
		return
	for i in element_dots.size():
		var dot : DotButton = element_dots[i]
		if dot.hovered:
			highlighted_dot = i
			break
	queue_redraw()

func _on_dot_selected(element:ConfigManager.VisualElements) ->void:
	dot_selected.emit(element)

func _draw() ->void:
	var e_colors := ConfigManager.get_element_colors()
	var e_intensities := DataManager.get_element_intensities()
	
	var center := size * graph_center
	var radius := center.x * graph_radius
	draw_circle(center, radius, graph_colors[0], false, 2.0)
	
	var element_positions : Array[Vector2]
	
	for i : int in element_dots.size():
		# Rotate from (0, -1) so that there's a dot at the top in the middle
		var dot_pos := Vector2(0.0, -1.0).rotated(i * (TAU/7.0))
		dot_pos = (dot_pos * radius) + center
		var dot_size = radius * dot_radius_ratios[e_intensities[i]]
		
		element_dots[i].size = Vector2(dot_size, dot_size)
		element_dots[i].position = (dot_pos - element_dots[i].size/2.0)
		element_dots[i].self_modulate = e_colors[i]
		
		element_positions.append(dot_pos)
	
	if highlighted_dot < 0:
		draw_relationships(element_positions)
	else:
		highlight_relationships(element_positions)

func draw_relationships(e_pos : Array[Vector2]) ->void:
	var e_relationships : Array = DataManager.get_all_relationships()
	for i : int in e_relationships.size():
		var num_relationships := 0
		for j : int in e_relationships[i].size():
			match(int(e_relationships[i][j])):
				0:
					continue
				1: # Affinity
					draw_line(e_pos[i], e_pos[j], ConfigManager.get_relationship_color(ConfigManager.RelationshipState.AFFINITY), 2.0)
					num_relationships += 1
				2: # Contrast
					draw_dashed_line(e_pos[i], e_pos[j], ConfigManager.get_relationship_color(ConfigManager.RelationshipState.CONTRAST), 2.0)
					num_relationships += 1
		element_dots[i].update_tooltip(num_relationships)

func highlight_relationships(e_pos : Array[Vector2]) ->void:
	var e_relationships : Array = DataManager.get_all_relationships()
	for i : int in e_relationships.size():
		if i == highlighted_dot:
			continue
		
		for j : int in e_relationships[i].size():
			match(int(e_relationships[i][j])):
				0:
					continue
				1: # Affinity
					draw_line(e_pos[i], e_pos[j], graph_colors[0], 2.0)
				2: # Contrast
					draw_dashed_line(e_pos[i], e_pos[j], graph_colors[0], 2.0)
	
	for i : int in e_relationships[highlighted_dot].size():
		match(int(e_relationships[highlighted_dot][i])):
			0:
				continue
			1: # Affinity
				draw_line(e_pos[highlighted_dot], e_pos[i], ConfigManager.get_relationship_color(ConfigManager.RelationshipState.AFFINITY), 2.0)
			2: # Contrast
				draw_dashed_line(e_pos[highlighted_dot], e_pos[i], ConfigManager.get_relationship_color(ConfigManager.RelationshipState.CONTRAST), 2.0)
