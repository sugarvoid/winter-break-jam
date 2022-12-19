extends Control

const DEFAULT_COLOR: Color = Color("96ecff")
const HIGHLIGHT_COLOR: Color = Color.darkorange

onready var option_list: Control = get_node("Options")

var selected_option: int = 0
var is_credits_showing: bool = false


func _ready():
	_highlight_selected_option() 

func _input(event):
	if !is_credits_showing:
		if Input.is_action_just_released("ui_accept"):
			_make_selection(self.selected_option)
		if Input.is_action_just_pressed("ui_up"):
			_move_up()
			_highlight_selected_option()
		if Input.is_action_just_pressed("ui_down"):
			_move_down()
			_highlight_selected_option()
	else:
		if Input.is_action_just_pressed("ui_cancel"):
			# Hid Credits 
			pass

func _make_selection(n: int) -> void:
	match(n):
		0: # Play
			get_tree().change_scene("res://game/game.tscn")
		1: # Credits
			pass
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
