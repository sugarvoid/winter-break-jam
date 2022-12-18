extends Node2D


const p_IceSickle: PackedScene = preload("res://game/danger_object/ice_sickle/ice_sickle.tscn")

const p_SWTopLeft: PackedScene = preload("res://game/danger_object/wave/sickle_wave_top_left.tscn")

func _ready():
	spawn_ice_sickle()

func spawn_ice_sickle(pos: Vector2 = $Position2D.global_position, rot: int = 0) -> void:
	var new_sickle: DangerObject = p_IceSickle.instance()
	new_sickle.rotation_d = rot
	new_sickle.global_position = pos
	self.call_deferred("add_child", new_sickle)
	
func _spawn_wave(wave: PackedScene) -> void:
	var new_wave = wave.instance()
	self.add_child(new_wave)

func spawn_hazard(sec: int) -> void:
	match sec:
		2, 10:
			_spawn_wave(p_SWTopLeft)
		4:
			spawn_ice_sickle()
		12:
			_spawn_wave(p_SWTopLeft)
