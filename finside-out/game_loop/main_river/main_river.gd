extends Node2D

@onready var element_spawner : ElementSpawner = $ElementSpawner
@onready var map : MapRiver = $Map
@onready var players : PlayersModifier = $Players
@onready var state : State = $State
@onready var piranhas : Piranhas = $Piranhas
@onready var tutorial := $Tutorial

func _ready() -> void:
	players.preactivate()
	element_spawner.preactivate()
	state.activate()
	map.activate()
	element_spawner.activate()
	players.activate(element_spawner)
	piranhas.activate()
	
	await get_tree().process_frame
	
	var display_tutorial := not (OS.is_debug_build() and Global.config.debug_skip_pregame)
	if display_tutorial:
		tutorial.activate()
		await tutorial.done
		print("Game fully started!")
