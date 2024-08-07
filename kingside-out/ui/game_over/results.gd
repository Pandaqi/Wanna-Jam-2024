extends Node2D

@export var result_scene : PackedScene
@export var players_data : PlayersData
@export var state_data : StateData

var result_node_size := Vector2(1536, 256)
var total_size := Vector2.ZERO

func _ready() -> void:
	GSignalBus.game_over.connect(on_game_over)
	get_tree().get_root().size_changed.connect(on_resize)
	on_resize()
	set_visible(false)

func on_resize() -> void:
	var vp_size := get_viewport_rect().size
	set_position(0.5 * vp_size)
	
	var match_scale = min(vp_size.x / total_size.x, vp_size.y / total_size.y)
	set_scale(Vector2.ONE * match_scale)

func on_game_over(_we_won:bool) -> void:
	
	# @TODO: display something entirely different depending on whether we won or lost
	
	get_tree().paused = true
	set_visible(true)
	
	var num_players = players_data.players.size()
	
	var offset_per_node := Vector2.DOWN * result_node_size
	var global_offset = -0.5 * (num_players - 1) * offset_per_node
	var delay_per_node := 0.2
	
	var players_sorted : Array[Player] = players_data.players.duplicate(false)
	var sort_func := func(a:Player, b:Player):
		if state_data.get_finish_time_for(a) < state_data.get_finish_time_for(b): return true
		return false
	players_sorted.sort_custom(sort_func)
	
	total_size = Vector2(result_node_size.x, num_players * result_node_size.y)
	
	for i in range(num_players):
		var player = players_sorted[i]
		var finish_time := state_data.get_finish_time_for(player)
		
		var node = result_scene.instantiate()
		node.set_position(global_offset + i * offset_per_node)
		add_child(node)
		node.set_data(i, player.player_num, finish_time)
		
		node.set_scale(Vector2.ZERO)
		var tw = get_tree().create_tween()
		tw.tween_interval(i*delay_per_node)
		tw.tween_property(node, "scale", 1.2*Vector2.ONE, 0.1)
		tw.tween_property(node, "scale", Vector2.ONE, 0.2)
		tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	on_resize()

func _input(ev) -> void:
	if ev.is_action_released("game_over_restart"):
		get_tree().paused = false
		get_tree().reload_current_scene()
		return
	
	if ev.is_action_released("game_over_back"):
		get_tree().paused = false
		get_tree().change_scene_to_file("res://game_loop/input_select/input_select.tscn")
