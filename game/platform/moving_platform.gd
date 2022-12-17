extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity: Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta) -> void:
	self.position += Vector2(20, -20) * delta
	
