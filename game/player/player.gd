class_name Player
extends KinematicBody2D

signal fell_off_screen

const UP_DIRECTION: Vector2 = Vector2.UP

onready var animated_sprite: AnimatedSprite = get_node("AnimatedSprite")

var velocity: Vector2 = Vector2.ZERO
var speed: float =  300.0
var acceleration: float = 0.3
var friction: float = 1.0
var gravity: float = 2500.0
var horizontal_direction: int

var jumps: int = 0
var jump_strength: float =  500.0
var max_jumps: int = 2
var extra_jump_strength: float = 400.0

var is_dashing: bool = false
var is_grounded: bool


func _physics_process(delta: float) -> void:
	self.horizontal_direction = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	if better_is_on_floor(): 
		if !is_grounded:
			reset_jumps()
		is_grounded = true
	else: 
		is_grounded = false
	
	if Input.is_action_just_pressed("jump"):
		if better_is_on_floor():
			jumps += 1
			velocity.y = -jump_strength
		else:
			print('not on floor????')
			if jumps >= 1 and jumps <= max_jumps:
				velocity.y = -extra_jump_strength
				jumps +=1
	if Input.is_action_just_pressed("dash"):
		print("...dash...")
	
	if self.horizontal_direction != 0: 
		velocity.x = lerp(velocity.x, self.horizontal_direction * speed, acceleration)
	elif self.horizontal_direction == 0: 
		velocity.x = lerp(velocity.x, self.horizontal_direction * speed, friction)
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, UP_DIRECTION)
	
	if self.horizontal_direction > 0:
		animated_sprite.flip_h = false
	elif self.horizontal_direction < 0:
		animated_sprite.flip_h = true

func better_is_on_floor() -> bool:
	var arr: Array =[]
	if self.is_on_floor():
		if arr.size() <= 4:
			arr.append(true)
	return arr.has(true)

func reset_jumps() -> void:
	self.jumps = 0
