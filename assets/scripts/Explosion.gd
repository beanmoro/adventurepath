extends Particles2D

onready var explosionsound = $ExplosionSound

func _ready():
	if GLOBAL.sound:
		explosionsound.play()
	emitting = true

func _physics_process(_delta):
	
	if !emitting :
		queue_free()
