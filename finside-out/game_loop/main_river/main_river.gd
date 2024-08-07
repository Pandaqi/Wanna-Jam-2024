extends Node2D

@onready var element_spawner : ElementSpawner = $ElementSpawner
@onready var map : MapRiver = $Map
@onready var players : PlayersModifier = $Players
@onready var state : State = $State
@onready var piranhas : Piranhas = $Piranhas

func _ready() -> void:
	players.preactivate()
	element_spawner.preactivate()
	state.activate()
	map.activate()
	element_spawner.activate()
	players.activate(element_spawner)
	piranhas.activate()
