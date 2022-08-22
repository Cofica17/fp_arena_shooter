extends KinematicBody
class_name Player

onready var model = $Model
onready var camera = $Camera

export var character_model:PackedScene = preload("res://assets/characthers/models/godot_models/king.tscn") setget set_character_model
export var running_speed = 10
export var walking_speed = 4
export var stopping_speed_ground = 0.1
export var stopping_speed_ground_air = 0.02
export var turn_angle = 0.05
export var gravity = Vector3(0, -35, 0)
export var jump_strength = 15
export var jump_strength_walk_modifier = 0.7
export var backward_speed_modifier = 0.5
var is_double_jumping = false
var is_walk_jumping = false

var velocity = Vector3.ZERO

func _ready():
	pass

func set_character_model(v) -> void:
	if not $Model:
		return
	
	character_model = v
	for child in $Model.get_children():
		child.queue_free()
	$Model.add_child(character_model.instance())

func _physics_process(delta):
	apply_gravity(delta)
	handle_movement()
	handle_jump()
	velocity = move_and_slide(velocity, Vector3.UP)

func handle_jump() -> void:
	if Input.is_action_pressed("jump") and is_on_floor():
		is_double_jumping = false
		if Input.is_action_pressed("walk"):
			is_walk_jumping = true
			velocity.y = jump_strength * jump_strength_walk_modifier
		else:
			is_walk_jumping = false
			velocity.y = jump_strength 
		return
		
	elif Input.is_action_just_pressed("jump") and !is_double_jumping and !is_on_floor():
		is_double_jumping = true
		if is_walk_jumping:
			velocity.y = jump_strength * jump_strength_walk_modifier
			print("Double Walk Jump")
		else:
			velocity.y = jump_strength
			print("Double Run Jump")
		
func apply_gravity(delta) -> void:
	velocity += gravity * delta

func handle_movement() -> void:
	var vel_y = velocity.y
	print(velocity.length())
	var speed = 0
	if is_on_floor():
		velocity = lerp(velocity, Vector3.ZERO, stopping_speed_ground)
	else:
		velocity = lerp(velocity, Vector3.ZERO, stopping_speed_ground_air)
	
	if Input.is_action_pressed("walk") and is_on_floor():
		speed = walking_speed
	else:
		speed = running_speed
		
	if Input.is_action_pressed("move_forward"):
		velocity = global_transform.basis.z * speed
	if Input.is_action_pressed("move_back"):
		velocity = -global_transform.basis.z * speed
	
	if Input.is_action_pressed("move_left"):
		rotate_y(turn_angle)
	if Input.is_action_pressed("move_right"):
		rotate_y(-turn_angle)
	
	velocity.y = vel_y
