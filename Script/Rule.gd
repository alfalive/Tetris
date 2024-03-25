class_name Rule extends Node

var fieldArr: Array
const defaultXSpawn = 3
var lastMoveTime = 0
var isDone = false

var isTracking = false
var trackPos = Vector2(0, 0)
var trackSize: int
var trackColor = FieldColor.NONE
var trackArr = [[false, false, false, false],[false, false, false, false],[false, false, false, false],[false, false, false, false]]


func _init(fieldArr: Array):
	self.fieldArr = fieldArr
	lastMoveTime = Time.get_ticks_msec()
	resetTrack()


func resetTrack():
	trackPos.x = defaultXSpawn
	trackPos.y = 0
	isTracking = false
	for y in trackArr.size():
		for x in trackArr[0].size():
			trackArr[y][x] = false

func hasTrackSpace():
	for y in trackSize:
		for x in trackSize:
			if fieldArr[trackPos.y + y][trackPos.x + x] != FieldColor.NONE:
				return false
	return true

func step():
	if isDone:
		return RuleResult.DONE
	if !isTracking:
		if !hasTrackSpace():
			isDone = true
			return RuleResult.DONE
		spawnRandom()
		return RuleResult.RENDER
	if canMoveDown():
		var time = Time.get_ticks_msec()
		if time - lastMoveTime > 200:
			moveDown()
			lastMoveTime = time
			return RuleResult.RENDER
	else:
		resetTrack()
	return RuleResult.NONE

func isInRange(x, y: int):
	return (x >= 0) && (y >= 0) && (y < fieldArr.size()) && (x < fieldArr[0].size())

func assignTrack(x, y):
	trackArr[y][x] = true

func applyTrack():
	for y in trackSize:
		for x in trackSize:
			if trackArr[y][x]:
				fieldArr[trackPos.y + y][trackPos.x + x] = trackColor

func removeTrack():
	for y in trackSize:
		for x in trackSize:
			if trackArr[y][x]:
				fieldArr[trackPos.y + y][trackPos.x + x] = FieldColor.NONE

func spawnRandom():
	var num = (randi() % (FieldColor.State.size() - 1)) + 1
	trackColor = num
	match num:
		FieldColor.CYAN:
			trackSize = 4
			assignTrack(1, 0)
			assignTrack(1, 1)
			assignTrack(1, 2)
			assignTrack(1, 3)
		FieldColor.BLUE:
			trackSize = 3
			assignTrack(2, 0)
			assignTrack(1, 0)
			assignTrack(1, 1)
			assignTrack(1, 2)
		FieldColor.ORANGE:
			trackSize = 3
			assignTrack(0, 0)
			assignTrack(1, 0)
			assignTrack(1, 1)
			assignTrack(1, 2)
		FieldColor.YELLOW:
			trackPos.x += 1
			trackSize = 2
			assignTrack(0, 0)
			assignTrack(1, 0)
			assignTrack(0, 1)
			assignTrack(1, 1)
		FieldColor.GREEN:
			trackSize = 3
			assignTrack(1, 0)
			assignTrack(2, 0)
			assignTrack(0, 1)
			assignTrack(1, 1)
		FieldColor.PURPLE:
			trackSize = 3
			assignTrack(0, 0)
			assignTrack(1, 0)
			assignTrack(2, 0)
			assignTrack(1, 1)
		FieldColor.RED:
			trackSize = 3
			assignTrack(0, 0)
			assignTrack(1, 0)
			assignTrack(2, 1)
			assignTrack(1, 1)
	isTracking = true;
	applyTrack()

func moveDown():
	removeTrack()
	trackPos.y += 1
	applyTrack()

func isBelowFree(x, y: int):
	return isInRange(x, y + 1) && fieldArr[y + 1][x] == FieldColor.NONE

func isRightFree(x, y: int):
	return isInRange(x + 1, y) && fieldArr[y][x + 1] == FieldColor.NONE

func isLeftFree(x, y: int):
	return isInRange(x - 1, y) && fieldArr[y][x - 1] == FieldColor.NONE

func canMoveDown():
	for x in trackSize:
		for y in range(trackSize - 1, -1, -1):
			if trackArr[y][x]:
				if !isBelowFree(trackPos.x + x, trackPos.y + y):
					return false
				break
	return true

func canMoveRight():
	for y in trackSize:
		for x in range(trackSize - 1, -1, -1):
			if trackArr[y][x]:
				if !isRightFree(trackPos.x + x, trackPos.y + y):
					return false
				break
	return true

func canMoveLeft():
	for y in trackSize:
		for x in trackSize:
			if trackArr[y][x]:
				if !isLeftFree(trackPos.x + x, trackPos.y + y):
					return false
				break
	return true

# Player Action
func right():
	var result = canMoveRight()
	if result:
		removeTrack()
		trackPos.x += 1
		applyTrack()
	return result
	
func left():
	var result = canMoveLeft()
	if result:
		removeTrack()
		trackPos.x -= 1
		applyTrack()
	return result
	
func rotate():
	pass
	
func veryDown():
	pass
