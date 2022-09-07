extends Node2D

var grid_location = Vector2(16, 80)
var grid_scene = preload("res://scenes/Grid.tscn")
var fwuit_scene = preload("res://scenes/FollowingFwuit.tscn")

onready var current_grid = $Grid
var fwuits_revealed = 0

func _ready():
	randomize()
	$Audio/ResetChime.play()
# warning-ignore:return_value_discarded
	EventManager.connect("reset_game", self, "reset")
# warning-ignore:return_value_discarded
	EventManager.connect("add_fwuit", self, "add_fwuit")
# warning-ignore:return_value_discarded
	EventManager.connect("block_clicked", self, "block_clicked")
# warning-ignore:return_value_discarded
	EventManager.connect("game_won", self, "won")
# warning-ignore:return_value_discarded
	EventManager.connect("pickup", self, "pickup")
	EventManager.connect("eat", self, "eat")


func eat():
	$Audio/EatChime.play()


func pickup(pos, id):
	$Audio/PickupChime.play()
	var fwuit = fwuit_scene.instance()
	fwuit.position = pos
	fwuit.set_value(id)
	fwuit.set_eaten($Smiley.position)
	add_child(fwuit)

func reset():
	$CanvasLayer/Control3/CenterContainer/YouDidIt.visible = false
	$Audio/ResetChime.play()
	fwuits_revealed = 0
	update_ui()
	current_grid.queue_free()
	var grid = grid_scene.instance()
	current_grid = grid
	grid.position = grid_location
	add_child(grid)


func add_fwuit():
	$Camera2D.add_trauma(0.25)
	fwuits_revealed += 1
	update_ui()
	if fwuits_revealed >= 40:
		EventManager.emit_signal("game_won")
	else:
		$Audio/FwuitChime.play()



func block_clicked():
	$Audio/ClickChime.play()


func won():
	$CanvasLayer/Control3/CenterContainer/YouDidIt.visible = true
	$Audio/WonChime.play()


func update_ui():
	$CanvasLayer/Control/CenterContainer/VBoxContainer/FwuitsRevealed.text = "%d" % fwuits_revealed
