extends Control

onready var crosshair = $Crosshair/CrosshairAnimation
onready var player = Nodes.get_player()

var crosshair_offset = 0.01

func _ready():
	var viewport_size = get_viewport_rect().size
	crosshair.global_position = Vector2(viewport_size.x / 2, viewport_size.y / 2 + crosshair_offset * viewport_size.y)
	set_animation_frame(1)
	
func _physics_process(delta):
	pass

func set_animation_frame(value) -> void:
	crosshair.frame = value
	pass

func _on_Player_attacked():
	print("Cock")
	pass # Replace with function body.