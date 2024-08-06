extends Resource
class_name PlayersData

var players : Array[Player] = []

func reset() -> void:
	players = []

func add_player(p:Player) -> void:
	players.append(p)

func get_extreme_player(dir:int) -> Player:
	var worst_index : int = -dir*100000
	var worst_player : Player = players.front()
	
	for p in players:
		var idx = p.river_tracker.get_index_on_river_float()
		if dir*idx > dir*worst_index:
			worst_index = idx
			worst_player = p
	
	return worst_player

func get_last_place() -> Player:
	return get_extreme_player(-1)

func get_first_place() -> Player:
	return get_extreme_player(1)
	
