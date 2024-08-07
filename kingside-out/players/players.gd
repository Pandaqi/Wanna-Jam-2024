class_name PlayersModifier extends Node2D

@export var players_data : PlayersData
@export var canoe_scene : PackedScene
@export var player_scene : PackedScene
@export var map_data : RiverMapData

var num_players := -1

func activate(em:ElementSpawner) -> void:
	players_data.reset()
	
	GSignalBus.place_canoe.connect(on_canoe_requested)
	GInput.create_debugging_players()
	num_players = GInput.get_player_count()
	place_players(em)
	place_canoes()

func place_players(em:ElementSpawner) -> void:
	for i in range(num_players):
		place_player(i, em)

func place_player(num:int, em:ElementSpawner) -> void:
	var p = player_scene.instantiate()
	add_child(p)
	players_data.add_player(p)
	p.activate(num, em)

func place_canoes() -> void:
	var positions := map_data.get_starting_positions(num_players)
	for i in range(num_players):
		place_canoe(positions[i], players_data.players[i])

func on_canoe_requested(pos:Vector2, player:Player) -> void:
	call_deferred("place_canoe", pos, player)

func place_canoe(pos:Vector2, player:Player) -> void:
	var c = canoe_scene.instantiate()
	c.set_position(pos)
	GSignalBus.place_on_map.emit(c, "players")
	c.activate()
	player.vehicle_manager.connect_to(c, true)
