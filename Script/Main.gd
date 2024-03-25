extends Node

var Drawer = preload("res://Script/Drawer.gd")
var BackgroundTileTexture = preload("res://Sprite/BackgroundTile.png")
var TileTexture = preload("res://Sprite/Tile.png")
var Rule = preload("res://Script/Rule.gd")


var fieldArr: Array
var yCount = 20
var xCount = 10

var drawer: Drawer
var rule: Rule


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
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
	
	rule = Rule.new(fieldArr)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("right") && rule.right():
		drawer.queue_redraw()
	if Input.is_action_just_pressed("left") && rule.left():
		drawer.queue_redraw()
	match rule.step():
		RuleResult.RENDER:
			drawer.queue_redraw()
	pass
