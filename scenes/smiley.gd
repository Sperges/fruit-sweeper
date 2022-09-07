extends Node2D

var speed = 10.0
var max_mouse_dist = 512.0
var max_eye_dist = 6.0
var max_mouth_dist = max_eye_dist * 0.66
var timer: Timer

var max_blink_wait = 6.0
var min_blink_wait = 1.0

var won = false

func _ready():
	randomize()
	$AnimationPlayer.play("RESET")
	timer = Timer.new()
	add_child(timer)
# warning-ignore:return_value_discarded
	EventManager.connect("eat", self, "eat")
# warning-ignore:return_value_discarded
	EventManager.connect("add_fwuit", self, "surprise")
# warning-ignore:return_value_discarded
	EventManager.connect("game_won", self, "win")
# warning-ignore:return_value_discarded
	EventManager.connect("reset_game", self, "reset")
# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "blink")
	timer.wait_time = rand_range(min_blink_wait, max_blink_wait)
	timer.start()


func _physics_process(delta):
	var look_dir = position.direction_to(get_global_mouse_position())
	var distance = clamp(position.distance_to(get_global_mouse_position()), 0, max_mouse_dist) / max_mouse_dist
	$Eyes.position = lerp($Eyes.position, look_dir * max_eye_dist * distance, delta * speed)
	$Mouth.position = lerp($Mouth.position, look_dir * max_mouth_dist * distance, delta * speed)


func blink():
	$AnimationPlayer.queue("blink")
	timer.wait_time = rand_range(min_blink_wait, max_blink_wait)
	timer.start()


func surprise():
	if not won:
		$AnimationPlayer.play("surprise")

func win():
	won = true
	$AnimationPlayer.queue("won")

func reset():
	$AnimationPlayer.play("RESET")

func eat():
	$AnimationPlayer.play("chew")


func _on_Area2D_mouse_entered():
	$Mouth.frame = 2


func _on_Area2D_mouse_exited():
	if not $AnimationPlayer.current_animation == "chew":
		$Mouth.frame = 0

