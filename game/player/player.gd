class_name Player
extends KinematicBody2D

signal fell_off_screen
signal on_air_jump(effect, pos)
signal is_dying
signal on_death

const UP_DIRECTION: Vector2 = Vector2.UP
const p_JumpEffect: PackedScene = preload("res://game/player/jump_effect.tscn")

onready var animated_sprite: AnimatedSprite = get_node("AnimatedSprite")

var velocity: Vector2 = Vector2.ZERO
var speed: float =  130.0
var acceleration: float = 0.2

# TODO: Add two types of friction 1.0 for normal and 0.03 for "on ice"
var friction: float = 0.03
var gravity: float = 1000.0
var horizontal_direction: int

var jumps: int = 0
var jump_strength: float =  300.0
var max_jumps: int = 2
var extra_jump_strength: float = 230.0

var is_dashing: bool = false
var is_grounded: bool
var is_alive: bool = true
var is_on_ice: bool

var hp: int = 1

func _ready():
	animated_sprite.play("default")
	animated_sprite.connect("animation_finished", self, "_animation_finished")

func _physics_process(delta: float) -> void:
	
	if self.is_alive:
		self.horizontal_direction = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
		
		if better_is_on_floor(): 
			if !is_grounded:
				reset_jumps()
			is_grounded = true
		else: 
			is_grounded = false
		
		if Input.is_action_just_pressed("jump"):
			if jumps == 0:
				jumps += 1
				velocity.y = -jump_strength
			else:
				print('not on floor????')
				if jumps >= 1 and jumps <= max_jumps:
					self.emit_signal("on_air_jump", p_JumpEffect, $Position2D.global_position)
					$AnimationPlayer.play("flip")
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

func take_damage():
	if self.hp == 0:
		return
	#$CollisionShape2D.set_deferred("disabled", true)
	print("taking damage")
	self.hp -= 1
	if self.hp == 0:
		self.is_alive = false
		emit_signal("is_dying")
		_play_death_animation()

func _play_death_animation() -> void:
	print('player is dead')
	# Play animation
	animated_sprite.play("dying")


func _animation_finished():
	if animated_sprite.animation == "dying":
		emit_signal("on_death")
		self.queue_free()
