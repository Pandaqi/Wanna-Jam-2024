class_name PlayersModifier extends Node2D

@export var players_data : PlayersData
@export var canoe_scene : PackedScene
@export var player_scene : PackedScene
@export var map_data : RiverMapData

var num_players := -1

func activate(em:ElementSpawner) -> void:
	players_data.reset()
	
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

func place_canoes():
	var positions := map_data.get_starting_positions(num_players)
	for i in range(num_players):
		var c = canoe_scene.instantiate()
		c.set_position(positions[i])
		add_child(c)
		c.activate()
		
		players_data.players[i].vehicle_manager.connect_to(c)
