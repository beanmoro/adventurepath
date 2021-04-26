extends PathFollow2D

onready var animator = $Sprite/AnimationPlayer
onready var camera = $Camera2D
onready var origintex = $OriginTex
onready var dragtex = $DragTex
onready var mainSprite = $Sprite
onready var hitbox = $KinematicBody2D/CollisionShape2D
var speed = 0
export (float) var max_speed = 10
export (float) var accel = 1
export (float) var deaccel = 0.25

var originClick = Vector2()
var dragClick = Vector2()

var dead = false
var score = 0

signal dead_player

func _ready():
	var _connection0 = connect("dead_player", get_node("/root/Main/GUI"), "calculeScore")
	var _connection1 = connect("dead_player", get_node("/root/Main/GUI"), "showGUINode", [1])
	animator.play("stay")

func _physics_process(_delta):
	
	hitbox.disabled = dead
	
	origintex.position  = originClick
	dragtex.position = dragClick
	
	if GLOBAL.started:
		visible = true
	else:
		visible = false
		offset = 0
	
	if !dead:
		if Input.is_action_pressed("touch") :
			dragClick = get_local_mouse_position()
			animator.play("walk")
			speed = min(speed+accel, max_speed)
		else:
			speed = lerp(speed, 0, deaccel)
			animator.play("stay")
			
		if Input.is_action_just_pressed("touch"):
			originClick = get_local_mouse_position()
		
		score = floor(offset/50)
	else:
		TOOLS.saveData()
		emit_signal("dead_player")
		speed = 0
		hide()
	
	offset+=speed
	
		

func getPosition():
	return global_position

func hit():
	dead = true

func restart():
	offset = 0
	dead = false
	show()
	
