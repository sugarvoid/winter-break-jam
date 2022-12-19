class_name HazardManager
extends Node2D

onready var single_sickle_left_timer: Timer = get_node("SickleLeft")
onready var single_sickle_right_timer: Timer = get_node("SickleRight")

onready var single_left_pos: Position2D = get_node("SingleLeftPos")
onready var single_right_pos: Position2D = get_node("SingleRightPos")

const p_IceSickle: PackedScene = preload("res://game/danger_object/ice_sickle/ice_sickle.tscn")

const p_SWTopLeft: PackedScene = preload("res://game/danger_object/wave/sickle_wave_top_left.tscn")
const p_SWTopRight: PackedScene = preload("res://game/danger_object/wave/sickle_wave_top_right.tscn")

const p_SWLeftTop: PackedScene = preload("res://game/danger_object/wave/sickle_wave_left_top.tscn")
const p_SWLeftBottom: PackedScene = preload("res://game/danger_object/wave/sickle_wave_left_bottom.tscn")

var left_timer: int = 2
var right_timer: int = 1

func _ready():
	single_sickle_left_timer.connect("timeout", self, "_on_left_timeout")
	single_sickle_right_timer.connect("timeout", self, "_on_right_timeout")


func start_timers() -> void:
	single_sickle_left_timer.start(self.left_timer)
	single_sickle_right_timer.start(self.right_timer)

func _spawn_ice_sickle(pos: Vector2 = $Position2D.global_position, dir: int = 0, speed = 30) -> void:
	var new_sickle: DangerObject = p_IceSickle.instance()
	new_sickle.speed = speed
	new_sickle.rotation_d = dir
	new_sickle.global_position = pos
	self.call_deferred("add_child", new_sickle)

func reset_self() -> void:
	single_sickle_left_timer.stop()
	single_sickle_right_timer.stop()

func _spawn_wave(wave: PackedScene) -> void:
	var new_wave = wave.instance()
	self.call_deferred("add_child", new_wave)

func _on_left_timeout() -> void:
	print('left')
	_spawn_ice_sickle(single_left_pos.global_position, DangerObject.MOVING_DIRECTION.RIGHT, 60)

func _on_right_timeout() -> void:
	print('right')
	_spawn_ice_sickle(single_right_pos.global_position, DangerObject.MOVING_DIRECTION.LEFT, 100)

func spawn_hazard(sec: int) -> void:
	pass
	match sec:
		2, 10:
			_spawn_wave(p_SWTopLeft)
		4:
			_spawn_ice_sickle()
		5:
			_spawn_wave(p_SWTopRight)
		6:
			_spawn_ice_sickle($Position2D2.global_position, DangerObject.MOVING_DIRECTION.RIGHT)
			_spawn_ice_sickle($Position2D.global_position, DangerObject.MOVING_DIRECTION.RIGHT)
		12:
			_spawn_wave(p_SWTopLeft)
		15:
			_spawn_wave(p_SWLeftBottom)
		16:
			_spawn_wave(p_SWLeftBottom)
