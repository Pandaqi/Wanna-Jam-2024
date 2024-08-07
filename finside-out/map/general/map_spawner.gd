class_name MapSpawner extends Resource

@export var all_elements : Array[ElementData] = []
var available_elements : Array[ElementData] = []

func get_random_available_element() -> ElementData:
	return available_elements.pick_random()

func query_position(_params:Dictionary) -> Vector2:
	return Vector2.ZERO

func get_positions_along_edges(_step_bounds:Bounds) -> Array[PossibleSpawnPoint]:
	return []

func get_positions_within(_step_bounds:Bounds) -> Array[PossibleSpawnPoint]:
	return []
