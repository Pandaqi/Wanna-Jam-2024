class_name State extends Node

@export var state_data : StateData
@export var players_data : PlayersData

var start_time := 0.0

func activate() -> void:
	state_data.reset()
	start_time = Time.get_ticks_msec()
	Global.player_finished.connect(on_player_finished)

func get_cur_time() -> float:
	return (Time.get_ticks_msec() - start_time) / 1000.0

func on_player_finished(num:int) -> void:
	state_data.record_time(num, get_cur_time())

	var all_players_finished := true
	for player in players_data.players:
		if not player.finished:
			all_players_finished = false
			break
	
	if not all_players_finished: return
	
	print("Game Over!")
	Global.game_over.emit()
