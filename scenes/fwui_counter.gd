extends Label


var fwuits = 0

func _ready():
	EventManager.connect("add_fwuit", self, "add_fwuit")
	EventManager.connect("reset_game", self, "reset")


func add_fwuit():
	fwuits += 1
	text = "%d" % fwuits


func reset():
	fwuits = 0
	text = "%d" % fwuits
