extends Node2D

@onready var icon : Sprite2D = $PlayerIcon
@onready var label_rank : Label = $LabelRank
@onready var label_time : Label = $LabelTime

func set_data(rank: int, num:int, time:float) -> void:
	icon.set_frame(4 + num)
	label_rank.set_text("#" + str(rank + 1))
	label_time.set_text(format_time_nicely(time))

func format_time_nicely(input_ms:float) -> String:
	var minutes = int(floor(input_ms / 1000.0 / 60.0))
	if minutes < 10:
		minutes = "0" + str(minutes)
	
	var seconds = int(floor(input_ms / 1000.0)) % 60
	if seconds < 10:
		seconds = "0" + str(seconds)
	
	var milliseconds = int(floor(input_ms)) % 1000 # this gives us four numbers
	milliseconds = int(round(milliseconds / 100.0)) # this gives us only two most important numbers
	if milliseconds < 10:
		milliseconds = "0" + str(milliseconds)
	
	return str(minutes) + ":" + str(seconds) + ":" + str(milliseconds)
