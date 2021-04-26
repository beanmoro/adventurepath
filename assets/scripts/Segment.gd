extends Line2D



onready var camera = get_node("/root/Main/Path2D/Player/Camera2D")
var from = Vector2()

func _ready():
	add_to_group("Segments")

func _physics_process(_delta):
	visible = GLOBAL.started
	if camera.global_position.x-600 > from.x:
		queue_free()
	
	

func create(_from, to, color, _width):
	default_color = color
	from = _from
	add_point(from)
	add_point(to)
	width = _width
	
