extends Node2D


const p_IceSickle: PackedScene = preload("res://game/danger_object/ice_sickle/ice_sickle.tscn")

func _ready():
	spawn_ice_sickle()

func spawn_ice_sickle() -> void:
	var new_sickle: DangerObject = p_IceSickle.instance()
	new_sickle.rotation_d = 0
	new_sickle.global_position = $Position2D.global_position
	self.add_child(new_sickle)

