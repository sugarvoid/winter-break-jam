extends Node2D


onready var player: Player = get_node("Player")
onready var kill_zone: Area2D = get_node("KillZone")
onready var effect_conatainer: EffectContainer = get_node("EffectContainer")

func _ready():
	_connection_child_signals() 

func _spawn_player() -> void:
	pass

func _respawn_player(_body: Node) -> void:
	self.player.global_position = $PlayerSpawnPoint.global_position
	print("respawning player.")

func _connection_child_signals() -> void:
	self.player.connect("fell_off_screen", self, "_respawn_player")
	self.kill_zone.connect("body_entered", self, "_respawn_player")
	self.player.connect("on_air_jump", self.effect_conatainer, "add_effect_to_screen")
