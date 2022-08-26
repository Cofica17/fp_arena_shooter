extends Spatial

export(NodePath) var PlayerPath  = "" #You must specify this in the inspector!
export(float) var mouse_sensitivity = 4
export var rot_x_limit = 25
onready var inner_gimbal = $InnerGimbal

var player:Player
var rot := Vector2.ZERO

func _ready():
	player = get_node(PlayerPath)

func _unhandled_input(event):
	if event is InputEventMouseMotion :
		rot = event.relative

func _physics_process(delta):
	player.rotate_y(deg2rad(-rot.x)*delta*mouse_sensitivity)
	inner_gimbal.rotate_x(deg2rad(rot.y)*delta*mouse_sensitivity)
	inner_gimbal.rotation_degrees.x = clamp(inner_gimbal.rotation_degrees.x, -rot_x_limit, rot_x_limit)
	rot = Vector2()