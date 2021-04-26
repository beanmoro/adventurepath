extends Sprite

onready var camera = get_node("/root/Main/Path2D/Player/Camera2D")

func _ready():
	add_to_group("Vegetation")
	material = material.duplicate()
	get_material().set_shader_param('global_transform', get_global_transform())


func _process(_delta):
	
	if global_position.x > (camera.global_position.x-400) and global_position.x < (camera.global_position.x+400) :
		show()
	elif global_position.x < (camera.global_position.x-400) :
		queue_free()
	else:
		hide()
	
	
		
			
	
	
