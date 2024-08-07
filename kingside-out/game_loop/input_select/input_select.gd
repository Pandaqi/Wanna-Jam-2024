class_name InputSelect extends Node2D

@export var player_select_scene : PackedScene
var player_selects : Array[PlayerSelect] = []
var player_select_size := Vector2(4,8) * 128.0
var total_size := Vector2.ZERO

func _ready() -> void:
	prepare_nodes()
	refresh_nodes()
	
	get_tree().get_root().size_changed.connect(on_resize)
	on_resize()

func on_resize() -> void:
	var vp_size := get_viewport_rect().size
	set_position(0.5 * vp_size)
	
	var match_scale = min(vp_size.x / total_size.x, vp_size.y / total_size.y)
	set_scale(Vector2.ONE * match_scale)

func prepare_nodes() -> void:
	var max_players := 4
	
	var offset_per_node := Vector2.RIGHT * player_select_size
	var global_offset := -0.5 * (max_players - 1) * offset_per_node
	
	total_size = Vector2(player_select_size.x * max_players, player_select_size.y)
	
	for i in range(max_players):
		var pss = player_select_scene.instantiate()
		pss.set_position(global_offset + i*offset_per_node)
		player_selects.append(pss)
		add_child(pss)
		pss.readied_up.connect(on_player_readied)
		pss.set_data(i)

func on_player_readied() -> void:
	var num_needed := GInput.get_player_count()
	var num_ready := 0
	for node in player_selects:
		if node.is_ready: num_ready += 1
	
	var should_start := num_ready >= num_needed
	if not should_start: return
	
	get_tree().change_scene_to_packed(preload("res://game_loop/main_river/main_river.tscn"))

func _input(ev):
	var res_add := GInput.check_new_player(ev)
	if res_add.is_success():
		refresh_nodes()
		return
	
	var res_remove := GInput.check_remove_player(ev)
	if res_remove.is_success():
		refresh_nodes()
		return

func refresh_nodes() -> void:
	var num_players := GInput.get_player_count()
	for i in range(4):
		var node := player_selects[i]
		var should_activate := i < num_players
		var next_node_up := i == GInput.get_player_count()
		if should_activate: node.activate()
		else: node.deactivate(next_node_up)
		
