extends Node2D

onready var path = get_parent().get_node("Path2D")
var segment = preload("../scenes/Segment.tscn")


func _ready():
	#create_line()
	pass


func create_line(from, to):
	var l = segment.instance()
	l.create(from, to, Color("f0a500"), 8)
	add_child(l)
