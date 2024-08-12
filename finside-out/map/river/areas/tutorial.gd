extends Node2D

@onready var arrow1 : Sprite2D = $Arrow1
@onready var arrow2 : Sprite2D = $Arrow2
@onready var element : Sprite2D = $Element
@onready var label : Label = $Label

func _ready():
	var size_bounds := Global.config.tutorial_size * Global.config.get_map_base_size()
	var new_scale := size_bounds / 512.0 * Vector2.ONE
	set_scale(new_scale)

func set_data(ed:ElementData, flip_arrow:bool) -> void:
	arrow1.flip_h = flip_arrow
	arrow2.flip_h = flip_arrow
	element.set_frame(ed.frame)
	label.set_text(ed.desc)
