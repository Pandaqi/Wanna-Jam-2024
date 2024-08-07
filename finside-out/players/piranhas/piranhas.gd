class_name Piranhas extends Node2D


@export var map_data : RiverMapData
@export var piranha_scene : PackedScene
@export var state_data : StateData

var piranhas : Array[Piranha] = []
var perp_line : Line
var active := false

func activate() -> void:
	if not state_data.should_include_piranha(): return
	
	active = true
	var num := Global.config.piranha_num_bounds.rand_int()
	var start_line := map_data.get_start_extreme()
	for i in range(num):
		place_piranha(start_line)

func place_piranha(line:Line) -> void:
	var p = piranha_scene.instantiate()
	p.set_position(line.rand_point())
	GSignalBus.place_on_map.emit(p, "players")
	p.activate()
	piranhas.append(p)

func get_furthest_index() -> float:
	var furthest := 0.0
	for pir in piranhas:
		furthest = max(furthest, pir.cur_index)
	return furthest

func _process(_dt:float) -> void:
	if not active: return
	draw_perp_line()

func draw_perp_line() -> void:
	var furthest_index := get_furthest_index()
	#print("Furthest idx", furthest_index)
	perp_line = map_data.get_perpendicular_line_at_index(furthest_index)
	queue_redraw()

func _draw() -> void:
	if not perp_line: return
	draw_line(perp_line.start, perp_line.end, Color(1,0,0), 32.0)
