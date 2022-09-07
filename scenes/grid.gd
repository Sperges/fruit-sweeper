extends Node2D


var block_scene = preload("res://scenes/Block.tscn")

var width = 16
var height = 16
var tile_size = 32

var fwuits = 40

func _unhandled_input(_event):
	if Input.is_action_just_pressed("win"):
		for y in height:
			for x in width:
				check_block(get_block(x, y))
	if Input.is_action_just_pressed("reveal"):
		for y in height:
			for x in width:
				check_cascade(x, y)


func _ready():
	randomize()
	for y in height:
		for x in width:
			spawn_block(x, y)
	for i in fwuits:
		var x = randi() % width
		var y = randi() % height
		var block = get_block(x, y) as Block
		while block.has_fwuit == true:
			x = randi() % width
			y = randi() % height
			block = get_block(x, y) as Block
		block.has_fwuit = true

func get_coords(id):
	return Vector2(id % width, id / width)

func get_block(x, y):
	if x < 0 or y < 0 or x >= width or y >= height:
		return null
	return get_child(y * width + x)

func spawn_block(x, y):
	var block = block_scene.instance()
	block.position = Vector2(x * tile_size, y * tile_size)
	block.connect("clicked", self, "block_clicked")
	add_child(block)


func get_info(x, y):
	var result = 0
	for i in range(-1, 2):
		for j in range(-1, 2):
			var block = get_block(x+i, y+j) as Block
			if block and block.has_fwuit:
				result += 1
	return result


func block_clicked(clicked_block: Block):
	check_block(clicked_block)


func check_block(clicked_block: Block):
	var coords = get_coords(clicked_block.get_index())
	var info = get_info(coords.x, coords.y)
	clicked_block.reveal(info)
	if info == 0:
		cascade(coords.x, coords.y)


func cascade(x, y):
	for i in range(-1, 2):
		for j in range(-1, 2):
			check_cascade(x+i, y+j)


func check_cascade(x, y):
	var block = get_block(x, y)
	if not block:
		return
	if block.covered and not block.has_fwuit:
		check_block(block)
