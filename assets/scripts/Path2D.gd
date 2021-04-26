extends Path2D

onready var line = get_parent().get_node("Line")
onready var camera = $Player/Camera2D
onready var player = $Player

var pivot = Vector2()
var dir = 0
var target = 0
var speed = 50
var segment_counter = 0
var oldOffset = 0

func _ready():
	
	pivot = position
	for _i in range(100):
		add_road()


func _physics_process(_delta):
	
	
	if floor(player.offset/100) != oldOffset:
		for _i in range(2):
			add_road()
		oldOffset = floor(player.offset/100)
	

func add_road():
	randomize()
	dir = lerp_angle(dir, target, 0.5)
	target = clamp(target+rand_range(-PI/4, PI/4), -PI/2, PI/2)	
	pivot += Vector2(cos(dir), sin(dir))*speed
	add_vegetation(1,-90, 30, 96, 160)
	add_vegetation(1, 90, 30, 96, 160)
	if segment_counter > 20:
		#print(segment_counter, " ", segment_counter/1000.0)
		add_enemy(90, 15, segment_counter/1000.0)
		add_enemy(-90, 15, segment_counter/1000.0)
	
	#print(dir)
	if curve.get_point_count()-1 >= 0:
		line.create_line(curve.get_point_position(curve.get_point_count()-1), pivot)
	curve.add_point(pivot)
	
		
	
	segment_counter+= 1
	
func add_enemy(direction, aperture, prob):
	randomize()
	
	var chance = randf()*1.0
	if chance < prob:
		var en_pivot = Vector2(cos(dir+deg2rad(direction)+deg2rad(rand_range(-aperture, aperture))), sin(dir+deg2rad(direction)+deg2rad(rand_range(-aperture, aperture))))*rand_range(64,128)
		var enemy = preload("../scenes/Tower.tscn").instance()
		enemy.position = en_pivot+pivot
		if chance > prob/5:
			enemy.follow_player = false
			enemy.predefined_dir = -en_pivot
		else:
			enemy.follow_player = true
		
		get_node("../Enemies").add_child(enemy)

func add_vegetation(number, direction, aperture, from, to):
	
	for _i in range(number):
		randomize()
		var bush_pivot = Vector2(cos(dir+deg2rad(direction)+deg2rad(rand_range(-aperture, aperture))), sin(dir+deg2rad(direction)+deg2rad(rand_range(-aperture, aperture))))*rand_range(from,to)
		var bush = preload("../scenes/Bush.tscn").instance()
		bush.position = bush_pivot+pivot
		get_node("../Vegetation").add_child(bush)
		
	
func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func restart():
	segment_counter = 0
	for _i in range(100):
		add_road()
		
