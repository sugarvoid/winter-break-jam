class_name DangerObject
extends Area2D

var speed = 30
export var rotation_d: int = 45

func _ready():
	rotation_degrees = self.rotation_d

func _process(delta):
	position += transform.x * speed * delta
