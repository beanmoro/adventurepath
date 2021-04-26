extends Control

var share = null # our share singleton instance
var image_save_path = ""

func _ready():
	# initialize the share singleton if it exists
	if Engine.has_singleton("GodotShare"):
		share = Engine.get_singleton("GodotShare")


func takeScreenshot():
	
	var old_clear_mode = get_viewport().get_clear_mode()
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	var img = get_viewport().get_texture().get_data()
	
	get_viewport().set_clear_mode(old_clear_mode)

	img.flip_y()

	image_save_path = OS.get_user_data_dir() + "/tmp.png"

	img.save_png(image_save_path)
	
	if share != null:
		share.sharePic(image_save_path, "Minion Path", "New Record!", str(GLOBAL.max_score)+"m is my new record on Minion Path! Can you beat me? Get Minion Path on Google Play http://blabla.com/minionpath")
	
	get_parent().get_node("GUI").showGUINode(1)
