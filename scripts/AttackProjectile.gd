extends KinematicBody

const PLAYER_GROUP = "Players"
const ENVIRONMENT_GROUP = "Environment"

onready var environment_group_members = get_tree().get_nodes_in_group(ENVIRONMENT_GROUP)[0].get_children()
onready var player_group_members = get_tree().get_nodes_in_group(PLAYER_GROUP)[0].get_children()
onready var player = Nodes.get_player()

export var gravity = Vector3(0, -10, 0)
export var velocity = Vector3.ZERO
export var speed = 150
export var destroy_distance = 200

var bullet_direction = Vector3.ZERO

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	apply_gravity(delta)
	collision_handler()
	proximity_handler()
	velocity = move_and_slide(velocity, Vector3.UP)
	
func apply_gravity(delta) -> void:
	velocity += gravity * delta

func set_bullet_direction(direction) -> void:
	velocity = direction * speed

func proximity_handler() -> void:
	if translation.distance_to(Nodes.get_player().translation) > destroy_distance:
		print("Went Far Away")
		queue_free()
		
func collision_handler() -> void:
	if get_last_slide_collision() != null:
		var collider_name = get_slide_collision(0).collider.name
		for env in player_group_members:
			if env.name == collider_name:
				print("Collided Player")
				queue_free()
				return
		for env in environment_group_members:
			if env.name == collider_name:
				print("Collided Environment")
				queue_free()
				return
