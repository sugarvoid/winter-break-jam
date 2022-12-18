extends Control


func _ready():
	pass 

func _input(event):
	if Input.is_action_just_released("ui_accept"):
		get_tree().change_scene("res://game/game.tscn")
