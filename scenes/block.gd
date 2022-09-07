extends Node2D
class_name Block

signal clicked

var picked = false
var covered = true
var has_fwuit = false
var x
var y

func reveal(info = 0):
	covered = false
	$Cover.visible = false
	$Base.visible = true
	if has_fwuit:
		$Fwuits.visible = true
		$Fwuits.set_value(randi() % 72)
		EventManager.emit_signal("add_fwuit")
	else:
		$Numbie.visible = true
		$Numbie.set_value(info)


func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if covered:
			EventManager.emit_signal("block_clicked")
			emit_signal("clicked", self)
		elif not covered and has_fwuit and not picked:
			picked = true
			$Fwuits.visible = false
			EventManager.emit_signal("pickup", global_position, $Fwuits.frame)
