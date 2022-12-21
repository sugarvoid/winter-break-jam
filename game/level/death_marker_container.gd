extends Node2D

const p_DeathMarker: PackedScene = preload("res://game/player/death_marker.tscn")

func add_marker_to_screen(pos: Vector2) -> void:
	var new_marker: Sprite = p_DeathMarker.instance()
	new_marker.global_position = pos
	self.add_child(new_marker)
