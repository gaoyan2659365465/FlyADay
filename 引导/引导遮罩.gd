class_name 引导遮罩 extends ColorRect



@onready var mask: ColorRect = $Mask


func _ready() -> void:
	self.visible = false

# 不同引导需要不同位置和尺寸的引导遮罩，使用前需要初始化
func initMask(rect:Rect2):
	mask.position = rect.position
	mask.size = rect.size

func 过渡动画():
	self.visible = true
	var tween = create_tween()
	tween.set_parallel(true)
	var _pos = mask.position
	var _size = mask.size
	# 放大到全屏
	mask.position = Vector2.ZERO
	mask.size = self.size
	tween.tween_property(mask,"position",_pos,0.5)
	tween.tween_property(mask,"size",_size,0.5)


# 只有遮罩区域才能点击，不能用gui_input，因为pass会阻挡按钮
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var rect = mask.get_rect()
		if rect.has_point(event.position):
			mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
		else:
			mouse_filter = MouseFilter.MOUSE_FILTER_STOP
