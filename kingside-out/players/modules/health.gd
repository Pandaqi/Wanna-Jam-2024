class_name ModuleHealth extends Node2D

@export var show_progress_bar := true

@onready var entity = get_parent()
@onready var anim_player : AnimationPlayer = $ProgBarCont/AnimationPlayer
@onready var prog_bar : TextureProgressBar = $ProgBarCont/TextureProgressBar
@onready var prog_bar_cont : Node2D = $ProgBarCont

var base_health := 100.0
var health := 0.0

signal depleted()

func _ready() -> void:
	prog_bar_cont.set_rotation(0)
	prog_bar_cont.set_visible(false)
	#remove_child(prog_bar_cont)
	#GSignalBus.place_on_map.emit(prog_bar_cont, "top")

func set_base_health(h:float, fill := false) -> void:
	base_health = h
	if fill: refill()

func drain() -> void:
	update_health(-health)

func refill() -> void:
	health = 0
	update_health(base_health)

func get_health_ratio() -> float:
	return health / base_health

func _process(_dt:float) -> void:
	if not show_progress_bar: return
	prog_bar_cont.set_position( entity.position )

func update_health(h:float) -> void:
	health = clamp(health + h, 0.0, base_health)
	
	prog_bar_cont.set_visible(show_progress_bar)
	if show_progress_bar:
		prog_bar.set_value(get_health_ratio() * 100)
		anim_player.stop()
		anim_player.play("appear_then_fade")
	
	if health <= 0:
		depleted.emit()

func on_size_changed(new_size:Vector2) -> void:
	var sc := new_size / Global.config.sprite_base_size
	set_scale(sc)
	prog_bar_cont.set_scale(sc)

func on_killed() -> void:
	prog_bar_cont.queue_free()
