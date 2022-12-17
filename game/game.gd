extends Node2D


onready var player: Player = get_node("Player")

func _ready():
	pass 

func _spawn_player() -> void:
	pass

func _respawn_player() -> void:
	print("respawning player.")

func _connection_child_signals() -> void:
	self.player.connect("fell_off_screen", self, "_respawn_player")
