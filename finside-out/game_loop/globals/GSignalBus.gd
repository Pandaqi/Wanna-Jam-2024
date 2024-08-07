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
