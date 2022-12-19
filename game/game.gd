extends Node2D


onready var player: Player = get_node("Player")
onready var kill_zone: Area2D = get_node("KillZone")
onready var effect_conatainer: EffectContainer = get_node("EffectContainer")
onready var gamer_timer: Timer = get_node("GameTimer")


var is_game_over: bool = false
var seconds_in: int

func _ready():
	_connection_child_signals() 
	_start_level()

func _spawn_player() -> void:
	pass

func _process(delta):
	pass

func _start_level() -> void:
	self.gamer_timer.start(1)

func _respawn_player(_body: Node) -> void:
#	if self.player.hp > 0:
#		self.player.global_position = $PlayerSpawnPoint.global_position
#		print("respawning player.")

	_game_over()

func _tick() -> void:
	if !is_game_over:
		seconds_in += 1
		print(str('tick ', seconds_in))
		$HazardManager.spawn_hazard(seconds_in)

func _remove_hazards() -> void:
	self.is_game_over = true
	self.call_deferred("remove_child", $HazardManager)# remove_child($HazardManager)

func _connection_child_signals() -> void:
	self.player.connect("fell_off_screen", self, "_respawn_player")
	self.player.connect("is_dying", self, "_remove_hazards")
	self.player.connect("on_death", self, "_game_over")
	self.kill_zone.connect("body_entered", self, "_respawn_player")
	self.player.connect("on_air_jump", self.effect_conatainer, "add_effect_to_screen")
	self.gamer_timer.connect("timeout", self, "_tick")
	
func _game_over():
	# Play gameover sound
	print('gameover')
