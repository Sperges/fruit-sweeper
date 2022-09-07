extends Node2D

var velocity = Vector2.ZERO
var speed = 1000

var direction = Vector2.ZERO
var distance = 0

var sprite: Sprite

var target = Vector2.ZERO
var eat_dist = 256

func _ready():
	sprite = $Fwuits
	sprite.frame = randi() % 72
	sprite.position = Vector2.ZERO

func _physics_process(delta):
	direction = lerp(direction, $KinematicBody2D.global_position.direction_to(get_global_mouse_position()), delta * 2)
	distance = lerp(distance, clamp($KinematicBody2D.global_position.distance_to(get_global_mouse_position()), 0, 100) / 100, delta * 2)
	
	$KinematicBody2D.move_and_slide(direction * speed * distance, Vector2.UP)
	
	sprite.global_position = lerp(sprite.global_position, $KinematicBody2D.global_position, delta * 5)

	if sprite.global_position.distance_squared_to(target) <= eat_dist:
		EventManager.emit_signal("eat")
		queue_free()

func set_value(val):
	yield(self, "ready")
	sprite.set_value(val)


func set_eaten(pos):
	yield(self, "ready")
	target = pos
