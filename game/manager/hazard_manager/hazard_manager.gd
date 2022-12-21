class_name HazardManager
extends Node2D

signal player_finished

onready var hazard_container: Node2D = get_node("HazardContainer")

onready var single_sickle_left_timer: Timer = get_node("SickleLeft")
onready var single_sickle_right_timer: Timer = get_node("SickleRight")

#onready var single_left_pos: Position2D = get_node("SingleLeftPos")
#onready var single_right_pos: Position2D = get_node("SingleRightPos")

const p_IceSickle: PackedScene = preload("res://game/danger_object/ice_sickle/ice_sickle.tscn")

const p_SWTopLeft: PackedScene = preload("res://game/danger_object/wave/sickle_wave_top_left.tscn")
const p_SWTopRight: PackedScene = preload("res://game/danger_object/wave/sickle_wave_top_right.tscn")

const p_SWLeftTop: PackedScene = preload("res://game/danger_object/wave/sickle_wave_left_top.tscn")
const p_SWLeftBottom: PackedScene = preload("res://game/danger_object/wave/sickle_wave_left_bottom.tscn")

const p_SWRightTop: PackedScene = preload("res://game/danger_object/wave/sickle_wave_right_top.tscn")
const p_SWRightBottom: PackedScene = preload("res://game/danger_object/wave/sickle_wave_right_bottom.tscn")

const p_SWLeftAll: PackedScene = preload("res://game/danger_object/wave/sickle_wave_left_all.tscn")


const p_SWAll: PackedScene = preload("res://game/danger_object/wave/sickle_wave_top_all.tscn")
const p_SWFinal: PackedScene = preload("res://game/danger_object/wave/sickle_wave_final.tscn")

var left_timer: int = 2
var right_timer: int = 3

func _ready():
	single_sickle_left_timer.connect("timeout", self, "_on_left_timeout")
	single_sickle_right_timer.connect("timeout", self, "_on_right_timeout")


func start_timers() -> void:
	single_sickle_left_timer.start(self.left_timer)
	single_sickle_right_timer.start(self.right_timer)

func _spawn_ice_sickle(spawn_pos: Vector2 = $L4.global_position, move_dir: int = 0, speed = 60) -> void:
	var new_sickle: DangerObject = p_IceSickle.instance()
	new_sickle.speed = speed
	new_sickle.rotation_d = move_dir
	new_sickle.global_position = spawn_pos
	self.hazard_container.call_deferred("add_child", new_sickle)


func reset_self() -> void:
	for c in self.hazard_container.get_children():
		c.call_deferred("queue_free")
		self._stop_timers()
	

func _stop_timers() -> void:
	single_sickle_left_timer.stop()
	single_sickle_right_timer.stop()

func _spawn_wave(wave_type: PackedScene, speed: int = 100) -> void:
	var new_wave: SickleWave = wave_type.instance()
	#new_wave.set_sickle_speed(speed)
	self.hazard_container.call_deferred("add_child", new_wave)

func _on_left_timeout() -> void:
	print('left')
	_spawn_ice_sickle($L4.global_position, DangerObject.MOVING_DIRECTION.RIGHT, 200)

func _on_right_timeout() -> void:
	print('right')
	_spawn_ice_sickle($R4.global_position, DangerObject.MOVING_DIRECTION.LEFT, 70)

func spawn_hazard(sec: int) -> void:
	match sec:
		1:
			_spawn_ice_sickle()
		2, 10:
			_spawn_wave(p_SWTopLeft, 150)
		3:
			_spawn_wave(p_SWRightTop)
		4:
			_spawn_ice_sickle()
		5:
			_spawn_wave(p_SWTopRight, 50)
		6:
			_spawn_wave(p_SWLeftTop, 80)
		7:
			_spawn_ice_sickle($L1.global_position, DangerObject.MOVING_DIRECTION.RIGHT)
			_spawn_ice_sickle($R2.global_position, DangerObject.MOVING_DIRECTION.RIGHT)
		8: 
			_stop_timers()
		12:
			start_timers()
			_spawn_wave(p_SWTopRight, 150)
			_spawn_wave(p_SWLeftBottom, 70)
			
		13:
			_spawn_wave(p_SWAll, 120)
		14:
			_spawn_wave(p_SWTopLeft, 200)
		15:
			_spawn_wave(p_SWLeftBottom, 180)
		16:
			_spawn_wave(p_SWLeftBottom, 175)
		17:
			_spawn_wave(p_SWAll, 80)
		18:
			_spawn_wave(p_SWRightTop)
			
		25:
			_spawn_wave(p_SWLeftAll)
		27:
			_spawn_wave(p_SWAll, 70)
		28:
			_spawn_wave(p_SWAll, 90)
		29:
			_spawn_wave(p_SWAll, 110)
		30:
			_spawn_wave(p_SWAll, 130)
		# 31 - 37 Shall be a break
		31:
			_stop_timers()
		38:
			_stop_timers()
			_spawn_wave(p_SWLeftBottom, 180)
		39:
			_spawn_wave(p_SWRightTop, 200)
		40:
			pass
		41:
			pass
		41:
			_spawn_wave(p_SWRightBottom)
		55:
			# last ones
			_spawn_wave()
		60:
			# End of game
			emit_signal("player_finished")
