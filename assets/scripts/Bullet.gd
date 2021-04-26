extends Area2D

var direction = 0
var speed = 100
var motion
onready var camera = get_node("/root/Main/Path2D/Player/Camera2D")
onready var explosion = preload("../scenes/Explosion.tscn")


func _ready():
	add_to_group("Bullets")
	var _connection0 =connect("body_entered", self, "_on_body_entered")

func create(pos, dir, spd):
	position = pos
	direction = dir
	speed = spd
	motion = Vector2(cos(direction), sin(direction))
	

func _physics_process(delta):
	if camera.global_position.x-400 > global_position.x:
		queue_free()
	
	position += motion * speed * delta
	

func _on_body_entered(body):
	var expl = explosion.instance()
	expl.position = position
	get_parent().add_child(expl)
	
	if body.get_parent().get_name() == "Player":
		body.get_parent().hit()
	
	queue_free()

