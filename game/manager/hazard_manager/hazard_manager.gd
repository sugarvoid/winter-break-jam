class_name HazardManager
extends Node2D

signal player_finished

onready var hazard_container: Node2D = get_node("HazardContainer")

onready var single_sickle_left_timer: Timer = get_node("SickleLeft")
onready var single_sickle_right_timer: Timer = get_node("SickleRight")

onready var single_left_pos: Position2D = get_node("SingleLeftPos")
onready var single_right_pos: Position2D = get_node("SingleRightPos")

const p_IceSickle: PackedScene = preload("res://game/danger_object/ice_sickle/ice_sickle.tscn")

const p_SWTopLeft: PackedScene = preload("res://game/danger_object/wave/sickle_wave_top_left.tscn")
const p_SWTopRight: PackedScene = preload("res://game/danger_object/wave/sickle_wave_top_right.tscn")

const p_SWLeftTop: PackedScene = preload("res://game/danger_object/wave/sickle_wave_left_top.tscn")
const p_SWLeftBottom: PackedScene = preload("res://game/danger_object/wave/sickle_wave_left_bottom.tscn")

const p_SWAll: PackedScene = preload("res://game/danger_object/wave/sickle_wave_top_all.tscn")

var left_timer: int = 2
var right_timer: int = 1

func _ready():
	single_sickle_left_timer.connect("timeout", self, "_on_left_timeout")
	single_sickle_right_timer.connect("timeout", self, "_on_right_timeout")


func start_timers() -> void:
	single_sickle_left_timer.start(self.left_timer)
	single_sickle_right_timer.start(self.right_timer)

func _spawn_ice_sickle(spawn_pos: Vector2 = $Position2D.global_position, move_dir: int = 0, speed = 60) -> void:
	var new_sickle: DangerObject = p_IceSickle.instance()
	new_sickle.speed = speed
	new_sickle.rotation_d = move_dir
	new_sickle.global_position = spawn_pos
	self.hazard_container.call_deferred("add_child", new_sickle)


func reset_self() -> void:
	for c in self.hazard_container.get_children():
		c.call_deferred("queue_free")
	single_sickle_left_timer.stop()
	single_sickle_right_timer.stop()

func _spawn_wave(wave_type: PackedScene, speed: int = 100) -> void:
	var new_wave: SickleWave = wave_type.instance()
	new_wave.set_sickle_speed(speed)
	self.hazard_container.call_deferred("add_child", new_wave)

func _on_left_timeout() -> void:
	print('left')
	_spawn_ice_sickle(single_left_pos.global_position, DangerObject.MOVING_DIRECTION.RIGHT, 80)

func _on_right_timeout() -> void:
	print('right')
	_spawn_ice_sickle(single_right_pos.global_position, DangerObject.MOVING_DIRECTION.LEFT, 100)

func spawn_hazard(sec: int) -> void:
	pass
	match sec:
		1:
			_spawn_ice_sickle()
		2, 10:
			_spawn_wave(p_SWTopLeft, 150)
		4:
			_spawn_ice_sickle()
		5:
			_spawn_wave(p_SWTopRight, 50)
		6:
			_spawn_wave(p_SWLeftTop, 80)
		7:
			_spawn_ice_sickle($Position2D2.global_position, DangerObject.MOVING_DIRECTION.RIGHT)
			_spawn_ice_sickle($Position2D.global_position, DangerObject.MOVING_DIRECTION.RIGHT)
		12:
			_spawn_wave(p_SWAll, 120)
		13:
			_spawn_wave(p_SWTopLeft, 200)
		15:
			_spawn_wave(p_SWLeftBottom, 180)
		16:
			_spawn_wave(p_SWLeftBottom, 175)
		17:
			_spawn_wave(p_SWAll, 80)
		118:
			# last ones
			pass
		120:
			emit_signal("player_finished")
