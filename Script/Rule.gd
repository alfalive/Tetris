class_name Rule extends Node

var fieldArr: Array
const defaultXSpawn = 3
var isTracking = false
var trackPos = Vector2(0, 0)
var trackSize: int


func _init(fieldArr: Array):
	self.fieldArr = fieldArr
	

func step():
	if !isTracking:
		spawnRandom()
		return true
	return false

func spawnRandom():
	trackPos.x = defaultXSpawn
	trackPos.y = 0
	
	var num = (randi() % (FieldColor.State.size() - 1)) + 1
	match num:
		FieldColor.CYAN:
			trackSize = 4
			fieldArr[trackPos.y + 0][trackPos.x + 1] = num
			fieldArr[trackPos.y + 1][trackPos.x + 1] = num
			fieldArr[trackPos.y + 2][trackPos.x + 1] = num
			fieldArr[trackPos.y + 3][trackPos.x + 1] = num
		FieldColor.BLUE:
			trackSize = 3
			fieldArr[trackPos.y + 0][trackPos.x + 2] = num
			fieldArr[trackPos.y + 0][trackPos.x + 1] = num
			fieldArr[trackPos.y + 1][trackPos.x + 1] = num
			fieldArr[trackPos.y + 2][trackPos.x + 1] = num
		FieldColor.ORANGE:
			trackSize = 3
			fieldArr[trackPos.y + 0][trackPos.x + 0] = num
			fieldArr[trackPos.y + 0][trackPos.x + 1] = num
			fieldArr[trackPos.y + 1][trackPos.x + 1] = num
			fieldArr[trackPos.y + 2][trackPos.x + 1] = num
		FieldColor.YELLOW:
			trackPos.x += 1
			trackSize = 2
			fieldArr[trackPos.y + 0][trackPos.x + 0] = num
			fieldArr[trackPos.y + 0][trackPos.x + 1] = num
			fieldArr[trackPos.y + 1][trackPos.x + 0] = num
			fieldArr[trackPos.y + 1][trackPos.x + 1] = num
			pass
		FieldColor.GREEN:
			trackSize = 3
			fieldArr[trackPos.y + 0][trackPos.x + 1] = num
			fieldArr[trackPos.y + 0][trackPos.x + 2] = num
			fieldArr[trackPos.y + 1][trackPos.x + 0] = num
			fieldArr[trackPos.y + 1][trackPos.x + 1] = num
			pass
		FieldColor.PURPLE:
			trackSize = 3
			fieldArr[trackPos.y + 0][trackPos.x + 0] = num
			fieldArr[trackPos.y + 0][trackPos.x + 1] = num
			fieldArr[trackPos.y + 0][trackPos.x + 2] = num
			fieldArr[trackPos.y + 1][trackPos.x + 1] = num
			pass
		FieldColor.RED:
			trackSize = 3
			fieldArr[trackPos.y + 0][trackPos.x + 0] = num
			fieldArr[trackPos.y + 0][trackPos.x + 1] = num
			fieldArr[trackPos.y + 1][trackPos.x + 2] = num
			fieldArr[trackPos.y + 1][trackPos.x + 1] = num	
			pass
	
	isTracking = true;

func moveDown():
	pass

# Player Action
func right():
	pass
	
func left():
	pass
	
func rotate():
	pass
	
func down():
	pass
