extends MultiMeshInstance2D

var currentDamageList = []
# 最大文本数
@export var maxDamageTextNum = 1000

# 初始生成间隔
var originGenGap = 0.5
#当前生成间隔
var currentGenGap = 0.5
# 最小生成间隔
var minGenGap = 0.0
# 上次生成时间
var lastGenTime = 0
var isGen = false

var currentTime = 0



class Number:
	var num : int
	var currentTransform : Transform2D
	var currentVelocity : Vector2

func _ready():
	self.multimesh.visible_instance_count = 0
	self.multimesh.instance_count = maxDamageTextNum

func _process(delta):
	currentTime += delta
	if isGen and lastGenTime + currentGenGap < currentTime:
		# 间隔生成数字
		var mousePos = get_local_mouse_position()
		lastGenTime = currentTime
		currentGenGap -= 0.02
		currentGenGap = max(minGenGap, currentGenGap)
		var num = randi_range(0, 999)
		var newNum = Number.new()
		newNum.num = randi_range(0, 999)
		newNum.currentTransform = Transform2D()
		newNum.currentTransform.origin = mousePos
		newNum.currentVelocity = Vector2(randi_range(-500,500), randi_range(-500,-1500))
		if currentDamageList.size() >= maxDamageTextNum:
			currentDamageList.pop_front()
		currentDamageList.append(newNum)

	self.multimesh.visible_instance_count = currentDamageList.size()
	var viewportSize = get_viewport_rect().size
	var removeList = []
	for index in range(currentDamageList.size()):
		var num = currentDamageList[index]
		var moveDir = num.currentVelocity * delta
		num.currentTransform.origin += moveDir
		num.currentVelocity -= Vector2(0, -9.8)
		if num.currentTransform.origin.y > viewportSize.y:
			removeList.append(num)
		multimesh.set_instance_custom_data(index, Color(num.num, getDigitCount(num.num), 0.0, 0.0))
		multimesh.set_instance_transform_2d(index, num.currentTransform)
	for num in removeList:
		currentDamageList.erase(num)

# 获取数字位数
func getDigitCount(number: int) -> int:
	var count = 0
	var num = abs(number)  # 取绝对值以处理负数情况
	if num == 0:
		return 1  # 数字为0时，位数为1
	while num > 0:
		num = num / 10
		count += 1
	return count

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			isGen = true
		else:
			isGen = false
			currentGenGap = originGenGap
