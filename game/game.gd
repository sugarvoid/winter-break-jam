extends Node2D

const START_DELAY: int = 3

onready var player: Player = get_node("Player")
onready var kill_zone: Area2D = get_node("KillZone")
onready var effect_conatainer: EffectContainer = get_node("EffectContainer")
onready var gamer_timer: Timer = get_node("GameTimer")
onready var static_platform_left: Platform = get_node("StaticPlatformLeft")
onready var static_platform_right: Platform = get_node("StaticPlatformRight")
onready var hazard_manager: HazardManager = get_node("HazardManager")
onready var start_delay_timer: Timer = get_node("StartDelay")
onready var gameover_sound: AudioStreamPlayer = get_node("GameOverSound")

var is_game_over: bool = false
var seconds_in: int

func _ready():
	self._connection_child_signals() 
	self._set_up_new_game()

func _set_up_new_game() -> void:
	$BackgroundMusic.play()
	_hide_overlay_items()
	self.is_game_over = false
	self._spawn_player()
	self.static_platform_left.is_frozen = true
	self.static_platform_right.is_frozen = true
	self.start_delay_timer.start(START_DELAY)
	self._start_level()

func _spawn_player() -> void:
	self.player.global_position = $PlayerSpawnPoint.global_position

func _hide_overlay_items() -> void:
	for c in $OverLay.get_children():
		c.visible = false

func _input(event):
	if self.is_game_over:
		if event.is_action_released("restart"):
			get_tree().change_scene("res://game/game.tscn")

func _start_level() -> void:
	if !is_game_over: # Prevents chrashing if player jumps of level before game startss
		self.gamer_timer.start(1)
		self.hazard_manager.start_timers()

func _respawn_player(_body: Node) -> void:
	self._end_game()

func _tick() -> void:
	if !is_game_over:
		self.seconds_in += 1
		print(str('tick ', self.seconds_in))
		self.hazard_manager.spawn_hazard(self.seconds_in)

func _remove_hazards() -> void:
	self.is_game_over = true
	self.hazard_manager.reset_self()

func _connection_child_signals() -> void:
	self.start_delay_timer.connect("timeout", self, "_start_level")
	self.player.connect("fell_off_screen", self, "_respawn_player")
	self.player.connect("is_dying", self, "_remove_hazards")
	# TODO: REMOVE ONCE I ADD SOUND
	#### self.player.connect("on_death", self, "_play_gameoever_sound")
	self.player.connect("on_death", self, "_end_game")
	self.kill_zone.connect("body_entered", self, "_respawn_player")
	self.player.connect("on_air_jump", self.effect_conatainer, "add_effect_to_screen")
	self.gamer_timer.connect("timeout", self, "_tick")
	self.gameover_sound.connect("finished", self, "_end_game")
	self.hazard_manager.connect("player_finished", self, "_game_won")

func _play_gameoever_sound() -> void:
	gameover_sound.play()

func _end_game():
	# Play gameover sound
	self._remove_hazards()
	$OverLay/LblRestart.visible = true
	print('gameover')

func _game_won() -> void:
	# play winning sound
	$OverLay/LblWin.visible = true
	print('You win!')
