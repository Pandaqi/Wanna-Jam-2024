extends Resource
class_name StateData

var finish_times : Dictionary = {}

func reset() -> void:
	finish_times = {}

# This is in MILLISECONDS
func record_time(num:int, tm:float) -> void:
	finish_times[num] = tm
	
func get_finish_time_for(p:Player) -> float:
	return finish_times[p.player_num] + p.effects_tracker.get_total_time_ms()
