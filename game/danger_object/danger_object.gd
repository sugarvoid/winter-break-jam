class_name DangerObject
extends Area2D

onready var vis_notifier: VisibilityNotifier2D = get_node("VisibilityNotifier2D")

enum MOVING_DIRECTION {
	LEFT = 180,
	RIGHT = 0, 
	DOWN = 90,
	UP = -90
}

export var speed = 30
export var rotation_d: int = 45

func _ready():
	rotation_degrees = self.rotation_d
	self.vis_notifier.connect("screen_exited", self, "queue_free")
	self.connect("body_entered", self, "_on_hit")

func _process(delta):
	position += transform.x * speed * delta
	
func _on_hit(body: Node) -> void:
	
	print(body)
	# shatter animation
	if body.has_method("take_damage"):
		body.take_damage() 
