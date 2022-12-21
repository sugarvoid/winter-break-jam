extends Control

const DEFAULT_COLOR: Color = Color("0c7ef7")
const HIGHLIGHT_COLOR: Color = Color("ededed")

onready var option_list: Control = get_node("Options")
onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
onready var title_music: AudioStreamPlayer = get_node("AudioStreamPlayer")

var selected_option: int = 0
var _is_credits_showing: bool = false


func _ready():
	_highlight_selected_option() 
	self.animation_player.play("title_sway")
	self.title_music.play(26.00)

func _input(event):
	if !_is_credits_showing:
		if event.is_action_just_released("ui_accept"):
			_make_selection(self.selected_option)
		if event.is_action_just_pressed("ui_up"):
			_move_up()
			_highlight_selected_option()
		if event.is_action_just_pressed("ui_down"):
			_move_down()
			_highlight_selected_option()
	else:
		if event.is_action_just_pressed("ui_cancel"):
			# Hid Credits 
			self._is_credits_showing = false

func _make_selection(n: int) -> void:
	match(n):
		0: # Play
			get_tree().change_scene("res://game/game.tscn")
		1: # Credits
			pass
			# Show Credits
			self._is_credits_showing = true
		2: # Quit
			get_tree().quit()

func _move_up() -> void:
	if selected_option == 0:
		selected_option = 2
	else:
		selected_option -= 1

func _move_down() -> void:
	if selected_option == 2:
		selected_option = 0
	else:
		selected_option += 1

func _highlight_selected_option() -> void:
	for l in option_list.get_children():
		l.set("custom_colors/font_color", DEFAULT_COLOR)
	
	option_list.get_child(self.selected_option).set("custom_colors/font_color", HIGHLIGHT_COLOR)
