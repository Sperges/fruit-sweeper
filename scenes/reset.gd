extends Button




func _on_Button_pressed():
	EventManager.emit_signal("reset_game")
