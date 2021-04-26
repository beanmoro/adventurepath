extends Node2D

onready var path = $Path2D
onready var player = $Path2D/Player
onready var gui = $GUI

func _ready():
	
	TOOLS.loadData()

func restart_game():
	
	for bul in get_tree().get_nodes_in_group("Bullets"):
		bul.get_parent().remove_child(bul)
		bul.queue_free()
		
	for tow in get_tree().get_nodes_in_group("Enemies"):
		tow.get_parent().remove_child(tow)
		tow.queue_free()
	
	for veg in get_tree().get_nodes_in_group("Vegetation"):
		veg.get_parent().remove_child(veg)
		veg.queue_free()
		
	for seg in get_tree().get_nodes_in_group("Segments"):
		seg.get_parent().remove_child(seg)
		seg.queue_free()
	
	gui.showGUINode(0)
	player.restart()
	path.curve.clear_points()
	path.restart()
	
	
func _on_GUI_restart():
	restart_game()



