extends Resource
class_name StateData

var finish_times : Dictionary = {}

func reset() -> void:
	finish_times = {}

func record_time(num:int, tm:float) -> void:
	finish_times[num] = tm
	
