class_name ModuleVehicleVisuals extends Node2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var entity : Vehicle = get_parent()
@export var player_sprite : PackedScene
@export var hide_sprite := false
@onready var anim_player : AnimationPlayer = $AnimationPlayer
@export var degrade_by_damage := false

var driver_sprites : Array[Sprite2D] = []
var body_size : Vector2

func activate(p:ModulePhysics) -> void:
	if hide_sprite: sprite.set_visible(false)
	
	p.ghost_changed.connect(on_ghost_changed)
	p.size_changed.connect(on_size_changed)
	entity.driver_added.connect(on_driver_added)
	entity.driver_removed.connect(on_driver_removed)
	
	if degrade_by_damage:
		entity.health.changed.connect(on_health_changed)

func on_size_changed(new_size:Vector2) -> void:
	body_size = new_size
	sprite.set_scale(new_size / Vector2(512, 512*0.5))
	visualize_drivers()

func on_driver_added(_p:Player, _side:Config.CanoeControlSide) -> void:
	visualize_drivers()

func on_driver_removed(_p:Player) -> void:
	visualize_drivers()

func visualize_drivers() -> void:
	var drivers := entity.connected_players
	var num := drivers.size()
	while driver_sprites.size() < num:
		var new_sprite = player_sprite.instantiate()
		add_child(new_sprite)
		driver_sprites.append(new_sprite)
	
	var sprite_scale := 0.75 * body_size.y / 512.0
	var offset_per_sprite := Vector2.RIGHT * sprite_scale
	var global_offset := -0.5 * (num - 1) * offset_per_sprite
	for i in range(driver_sprites.size()):
		var should_display := i < num
		var temp_sprite := driver_sprites[i]
		temp_sprite.set_visible(should_display)
		
		if not should_display: continue
		temp_sprite.set_scale(sprite_scale * Vector2.ONE)
		temp_sprite.set_frame(4 + drivers[i].player_num)
		temp_sprite.set_position(global_offset + i * offset_per_sprite)
		

func on_ghost_changed(val:bool) -> void:
	if not val: anim_player.stop()
	else: anim_player.play("ghost")

func on_health_changed(health_ratio:float) -> void:
	if not degrade_by_damage: return
	var frame : int = 3 - floor(health_ratio * 3.9999)
	sprite.set_frame(frame)
