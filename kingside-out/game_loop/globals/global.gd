extends Node

@export var config : Config

signal game_over(winning_player:int)
signal feedback(pos:Vector2, txt:String)
signal player_finished(player:int)
signal drop_element(sp:PossibleSpawnPoint)
