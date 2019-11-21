extends Node2D

const DIRECTION = Vector2(-0.2, 1)
const SPEED = 300

var colors = [Color.turquoise, Color.orangered, Color.goldenrod]

func _ready():
	$polygon_2d.color = colors[randi() % colors.size()]
	$polygon_2d.rotation = randf() * PI

func _physics_process(delta):
	position += DIRECTION * SPEED * delta
	
	if position.y > 660:
		queue_free()