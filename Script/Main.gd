extends Node

var Drawer = preload("res://Script/Drawer.gd")
var BackgroundTileTexture = preload("res://Sprite/BackgroundTile.png")
var TileTexture = preload("res://Sprite/Tile.png")
var fieldArr: Array
var yCount = 20
var xCount = 10

var drawer: Drawer


# Called when the node enters the scene tree for the first time.
func _ready():
	#get_viewport().size = Vector2(400, 800)
	#var vector = get_viewport().get_screen_transform()
	for y in yCount:
		fieldArr.append([])
		for x in xCount:
			fieldArr[y].append(0)
	drawer = Drawer.new(
		xCount,
		yCount,
		BackgroundTileTexture,
		TileTexture,
		fieldArr
	)
	add_child(drawer)
	pass

var i = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	drawer.queue_redraw()
	pass
