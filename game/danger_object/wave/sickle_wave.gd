extends Node2D


onready var child_checker: Timer = get_node("ChildChecker")
onready var hazards: Node2D = get_node("Hazards")

var child_speed: int = 100


func _ready():
	child_checker.connect("timeout", self, "_check_for_children")
	child_checker.start(2)
	
	for s in self.hazards.get_children():
		s.speed = child_speed
	

func _check_for_children() -> void:
	if self.hazards.get_child_count() == 0:
		self.queue_free()
