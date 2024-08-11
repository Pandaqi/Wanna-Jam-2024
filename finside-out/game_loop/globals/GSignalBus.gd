extends Node

signal game_over(we_won:bool)
signal feedback(pos:Vector2, txt:String)
signal player_finished(player:int)
signal player_killed(player:int)
signal drop_element(sp:PossibleSpawnPoint)
signal piranha_change(dp:float)
signal should_explode(pos:float)
signal place_on_map(obj, layer:String)
signal place_canoe(pos:Vector2, player:Player)

func _ready() -> void:
	var a = AudioStreamPlayer.new()
	a.stream = preload("res://game_loop/globals/theme_song_finside_out.ogg")
	a.volume_db = -14
	a.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(a)
	a.play()
