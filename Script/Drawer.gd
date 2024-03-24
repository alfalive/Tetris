class_name Drawer extends Node2D

const ColorMap = ['#FFFFFF', '#00FFFF', '#0476D0', '#FFA500', '#FDFD96', '#77DD77', '#8F00FF', '#FF033E']

var xCount = 10
var yCount = 20
var tileSize = 8
var backgroundTileTexture : Texture2D
var tileTexture : Texture2D
var fields : Array

func _init(
		AXCount, AYCount: int,
		ABackgroundTileTexture, ATileTexture: Texture2D,
		fieldArr: Array
	):
	xCount = AXCount
	yCount = AYCount
	backgroundTileTexture = ABackgroundTileTexture
	tileTexture = ATileTexture
	fields = fieldArr
	pass

func _ready():
	tileSize = min(backgroundTileTexture.get_width(), backgroundTileTexture.get_height())
	pass
	
func draw(x, y: int):
	if fields[y][x] == FieldColor.NONE:
		draw_texture(backgroundTileTexture, Vector2(tileSize * x, tileSize * y))
	else:
		draw_texture(tileTexture, Vector2(tileSize * x, tileSize * y), ColorMap[fields[y][x]])

func _draw():
	for y in yCount:
		for x in xCount:
			draw(x, y)










