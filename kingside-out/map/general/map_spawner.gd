class_name MapSpawner extends Resource

func query_position(_params:Dictionary) -> Vector2:
	return Vector2.ZERO

func get_positions_along_edges(_step_bounds:Bounds) -> Array[PossibleSpawnPoint]:
	return []

func get_positions_within(_step_bounds:Bounds) -> Array[PossibleSpawnPoint]:
	return []
