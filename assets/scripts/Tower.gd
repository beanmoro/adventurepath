extends Node2D

onready var base = $sprBase
onready var cannon = $sprCannon
onready var bullet = preload("../scenes/Bullet.tscn")
onready var bulletrate = $BulletRate
onready var camera = get_node("/root/Main/Path2D/Player/Camera2D")
onready var shootsound = $ShootSound

onready var player = get_node("/root/Main/Path2D/Player")

var dir
var spd
var shoot = false
var follow_player = false
var predefined_dir = 0
var distance

func _ready():	
	add_to_group("Enemies")
	
	if follow_player:
		distance = 192
	else:
		distance = 512
	spd = randi()%100+50
	#bulletrate.wait_time = randf()*0.1+1.5


func _physics_process(_delta):
	
	if global_position.x > (camera.global_position.x-400) and global_position.x < (camera.global_position.x+400) :
		show()
	elif global_position.x < (camera.global_position.x-400) :
		queue_free()
	else:
		hide()
	
	
	
	if base.global_position.distance_to(player.global_position) < distance and !player.dead:
		if follow_player :
			dir = (player.global_position - cannon.global_position).normalized().angle()+rand_range(-PI/16, PI/16)
			cannon.rotate(cannon.get_angle_to(player.position))
			#cannon.rotation = dir
		else:
			dir = predefined_dir.angle()+rand_range(-PI/16, PI/16)
			cannon.set_rotation(predefined_dir.angle())
		shoot = true
		if bulletrate.is_stopped():
			var b = bullet.instance()
			b.create(cannon.global_position, dir, spd)
			get_node("/root/Main/Bullets").add_child(b)
			if onScreen() and GLOBAL.sound:
				shootsound.play()
			bulletrate.start()
	else:
		shoot = false

func onScreen():
	if position.x > camera.global_position.x-(720/2) and position.x < camera.global_position.x+(720/2) and position.y > camera.global_position.y-(1280/2) and position.y < camera.global_position.y+(1280/2):
		return true
	return false
