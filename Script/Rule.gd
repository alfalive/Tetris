class_name Rule extends Node

var fieldArr: Array
const defaultXSpawn = 3
var lastMoveTime = 0
var isDone = false
var baseTickTime = 500
var currentTickTime = baseTickTime

var isTracking = false
var trackPos = Vector2(0, 0)
var trackSize: int
var trackColor = FieldColor.NONE
var trackArr = [[false, false, false, false],[false, false, false, false],[false, false, false, false],[false, false, false, false]]
var rotatedTrack = [[false, false, false, false],[false, false, false, false],[false, false, false, false],[false, false, false, false]]


func _init(fieldArr: Array):
	self.fieldArr = fieldArr
	lastMoveTime = Time.get_ticks_msec()
	resetTrack()

func zeroArray(arr: Array):
	for y in arr.size():
		for x in arr[0].size():
			arr[y][x] = false

func resetTrack():
	trackPos.x = defaultXSpawn
	trackPos.y = 0
	isTracking = false
	zeroArray(trackArr)
	removeFinishedRows()
	lastMoveTime = Time.get_ticks_msec()

func step():
	if isDone:
		return RuleResult.DONE
	if !isTracking:
		if !hasTrackSpace():
			isDone = true
			return RuleResult.DONE
		spawnRandom()
		return RuleResult.RENDER
	
	var time = Time.get_ticks_msec()
	if time - lastMoveTime > currentTickTime:
		if canMoveDown():
			moveDown()
			lastMoveTime = time
			return RuleResult.RENDER
		else:
			resetTrack()
	
	return RuleResult.NONE

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

func calcRotated():
	zeroArray(rotatedTrack)
	for y in trackSize:
		for x in trackSize:
			rotatedTrack[x][trackSize - y - 1] = trackArr[y][x]

func raycastDownDistance(x, y: int):
	var count = 1
	var combined = count + y
	while isInRange(x, combined) && fieldArr[combined][x] == FieldColor.NONE:
		count += 1
		combined = count + y
	return count - 1

func getVeryDownDistance():
	var distances = []
	for x in trackSize:
		for y in range(trackSize - 1, -1, -1):
			if trackArr[y][x]:
				var distance = raycastDownDistance(trackPos.x + x, trackPos.y + y)
				distances.append(distance)
				break
	var shortest = 1000
	for x in distances:
		if x < shortest:
			shortest = x
	return shortest

func getFinishedRow():
	for y in range(fieldArr.size()-1, 0, -1):
		var isFull = true
		for x in fieldArr[y].size():
			if fieldArr[y][x] == FieldColor.NONE:
				isFull = false
				break
		if isFull:
				return y
	return -1

func removeRow(row: int):
	for y in range(row, 0, -1):
		for x in fieldArr[0].size():
			fieldArr[y][x] = fieldArr[y-1][x]

func removeFinishedRows():
	var row = getFinishedRow()
	while row != -1:
		removeRow(row)
		row = getFinishedRow()

#Checks
func hasTrackSpace():
	for y in trackSize:
		for x in trackSize:
			if fieldArr[trackPos.y + y][trackPos.x + x] != FieldColor.NONE:
				return false
	return true

func isInRange(x, y: int):
	return (x >= 0) && (y >= 0) && (y < fieldArr.size()) && (x < fieldArr[0].size())

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

func canApply(arr: Array):
	for y in trackSize:
		for x in trackSize:
			var combinedX = trackPos.x + x
			var combinedY = trackPos.y + y
			if !isInRange(combinedX, combinedY) || fieldArr[combinedY][combinedX] != FieldColor.NONE && arr[y][x]:
				return false
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
	calcRotated()
	removeTrack()
	var result = canApply(rotatedTrack)
	if result:
		for y in trackSize:
			for x in trackSize:
				trackArr[y][x] = rotatedTrack[y][x]
	applyTrack()
	return result

func startSpeed():
	currentTickTime = 50

func stopSpeed():
	currentTickTime = baseTickTime

func veryDown():
	var x = getVeryDownDistance()
	removeTrack()
	trackPos.y += x
	applyTrack()
	resetTrack()
