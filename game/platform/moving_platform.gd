extends KinematicBody2D


var velocity: Vector2


func _process(delta) -> void:
	self.position += Vector2(20, -20) * delta
	
