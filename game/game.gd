extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player: Player = get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _spawn_player() -> void:
	pass

func _respawn_player() -> void:
	print("respawning player.")

func _connection_child_signals() -> void:
	self.player.connect("fell_off_screen", self, "_respawn_player")
