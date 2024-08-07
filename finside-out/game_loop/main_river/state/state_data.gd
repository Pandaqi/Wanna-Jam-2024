extends Resource
class_name StateData

@export var players_data : PlayersData
var finish_times : Dictionary = {}

func reset() -> void:
	finish_times = {}

# This is in MILLISECONDS
func record_time(num:int, tm:float) -> void:
	finish_times[num] = tm
	
func get_finish_time_for(p:Player) -> float:
	if not (p.player_num in finish_times): return 0.0
	return finish_times[p.player_num] + p.effects_tracker.get_total_time_ms()

func should_include_piranha() -> bool:
	return players_data.is_single_player()
