extends KinematicBody
class_name Player

onready var model = $Model
onready var camera = $Camera
onready var animation_player:AnimationPlayer = $AnimationPlayer

export var character_model:PackedScene = preload("res://assets/characthers/models/godot_models/king.tscn") setget set_character_model
export var running_speed = 15
export var walking_speed = 8
export var crouch_speed = 3
export var stopping_speed_ground = 0.1
export var turn_angle = 0.05
export var gravity = Vector3(0, -70, 0)
export var jump_strength = 30
export var backward_speed_modifier = 0.5
export var slide_idle_treshold = 2
#Stamina
export var stamina = 100
export var required_sprint_stamina = 1
export var max_stamina = 100
export var stamina_loss = 0.5
export var stamina_gain = 0.1
export var sprint_stamina_treshold = 20

var player_locomotion = PlayerLocomotion.new(self as KinematicBody)
var is_double_jumping = false
var is_jumping = false
var can_sprint = true
var prev_y = 0

var velocity = Vector3.ZERO

func _ready():
	#only the first state will be set by the player
	player_locomotion.set_state(player_locomotion.idle)

func set_character_model(v) -> void:
	if not $Model:
		return
	
	character_model = v
	for child in $Model.get_children():
		child.queue_free()
	$Model.add_child(character_model.instance())

func _physics_process(delta):
	#print(stamina)
	apply_gravity(delta)
	apply_stamina() 
	apply_sprint_state()
	player_locomotion._physics_process()
	velocity = move_and_slide(velocity, Vector3.UP)

func change_stamina(v):
	stamina += v

func apply_gravity(delta) -> void:
	velocity += gravity * delta

func apply_stamina() -> void:
	if stamina < max_stamina:
		change_stamina(stamina_gain)

func apply_sprint_state() -> void:
	if stamina < required_sprint_stamina:
		can_sprint = false
	if stamina >= sprint_stamina_treshold:
		can_sprint = true
