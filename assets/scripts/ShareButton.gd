extends TextureButton

onready var share = get_node("/root/Main/ShareService")

func _ready():
	connect("pressed", get_node("/root/Main/GUI"), "shareScreenshot")


