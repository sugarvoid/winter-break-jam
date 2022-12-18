extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var child_speed: int = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	for s in self.get_children():
		s.speed = child_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
