extends Node2D

### const p_Player: PackedScene = preload("res://game/player/player.tscn")

onready var player: Player = get_node("Player")
onready var kill_zone: Area2D = get_node("KillZone")
onready var effect_conatainer: EffectContainer = get_node("EffectContainer")
onready var gamer_timer: Timer = get_node("GameTimer")
onready var static_platform_left: Platform = get_node("StaticPlatformLeft")
onready var static_platform_right: Platform = get_node("StaticPlatformRight")
onready var hazard_manager: HazardManager = get_node("HazardManager")
onready var start_delay_timer: Timer = get_node("StartDelay")


var is_game_over: bool = false
var seconds_in: int

func _ready():
	_connection_child_signals() 
	_set_up_new_game()

func _set_up_new_game() -> void:
	self.is_game_over = false
	_spawn_player()
	
	static_platform_left.is_frozen = true
	static_platform_right.is_frozen = true
	start_delay_timer.start(3)
	_start_level()

func _spawn_player() -> void:
	self.player.global_position = $PlayerSpawnPoint.global_position


func _process(delta):
	pass

func _input(event):
	if self.is_game_over:
		if event.is_action_released("restart"):
			get_tree().change_scene("res://game/game.tscn")
			#_set_up_new_game()

func _start_level() -> void:
	if !is_game_over: # Prevents chrashing if player jumps of level before game startss
		self.gamer_timer.start(1)
		self.hazard_manager.start_timers()

func _respawn_player(_body: Node) -> void:
	_game_over()

func _tick() -> void:
	if !is_game_over:
		seconds_in += 1
		print(str('tick ', seconds_in))
		self.hazard_manager.spawn_hazard(seconds_in)

func _remove_hazards() -> void:
	self.is_game_over = true
	self.hazard_manager.reset_self()


func _connection_child_signals() -> void:
	self.start_delay_timer.connect("timeout", self, "_start_level")
	self.player.connect("fell_off_screen", self, "_respawn_player")
	self.player.connect("is_dying", self, "_remove_hazards")
	self.player.connect("on_death", self, "_game_over")
	self.kill_zone.connect("body_entered", self, "_respawn_player")
	self.player.connect("on_air_jump", self.effect_conatainer, "add_effect_to_screen")
	self.gamer_timer.connect("timeout", self, "_tick")
	
func _game_over():
	# Play gameover sound
	_remove_hazards()
	print('gameover')
