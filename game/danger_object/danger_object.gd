class_name DangerObject
extends Area2D

onready var vis_notifier: VisibilityNotifier2D = get_node("VisibilityNotifier2D")

var speed = 30
export var rotation_d: int = 45

func _ready():
	rotation_degrees = self.rotation_d
	self.vis_notifier.connect("screen_exited", self, "queue_free")

func _process(delta):
	position += transform.x * speed * delta
