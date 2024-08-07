class_name State extends Node

@export var state_data : StateData
@export var players_data : PlayersData

var start_time := 0.0

func activate() -> void:
	state_data.reset()
	start_time = Time.get_ticks_msec()
	GSignalBus.player_finished.connect(on_player_finished)
	GSignalBus.player_killed.connect(on_player_killed)

func get_cur_time() -> float:
	return Time.get_ticks_msec() - start_time

func on_player_finished(num:int) -> void:
	state_data.record_time(num, get_cur_time())

	var all_players_finished := true
	for player in players_data.players:
		if not player.finished:
			all_players_finished = false
			break
	
	if not all_players_finished: return
	
	print("Game Over! We won.")
	GSignalBus.game_over.emit(true)

func on_player_killed(num:int) -> void:
	state_data.record_time(num, get_cur_time())
	
	var players_allowed_to_be_dead := not state_data.should_include_piranha()
	if players_allowed_to_be_dead: return
	
	var all_players_killed := true
	for player in players_data.players:
		if not player.dead:
			all_players_killed = false
			break
	
	if not all_players_killed: return
	
	print("Game Over! We lost.")
	GSignalBus.game_over.emit(false)
