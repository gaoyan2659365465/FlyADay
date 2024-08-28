@tool
class_name ReorderableContainer
extends Container
## 允许子节点通过拖拽重新排序。
## 有滚动容器时支持自动滚动。

## 子对象被重新排序时触发
signal reordered(from: int, to: int)

## 扩展容器两端的“drop zone”区域长度
## 即使在容器边界之外也能识别到拖放操作
const DROP_ZONE_EXTEND = 2000

## 设置在拖拽持有子对象时，需要按住的时长（以秒为单位）。
## 只有在按住超过这个时长后，持有子对象才会开始被拖动。
@export 
var hold_duration := 0.5

## 子节点移动和排列的整体速度
@export_range(3, 30, 0.01, "or_greater", "or_less")
var speed := 10.0

## 容器元素之间的空间，以像素为单位。
@export 
var separation := 10: set = set_separation
func set_separation(value):
	if value == separation or value < 0:
		return
	separation = value
	_on_sort_children()


## 是否垂直排列
@export var is_vertical := false: set = set_vertical
func set_vertical(value):
	if value == is_vertical:
		return
	is_vertical = value
	if is_vertical:
		custom_minimum_size.x = 0
	else:
		custom_minimum_size.y = 0
	_on_sort_children()

## 自动查找父节点中的 ScrollContainer；若自动查找不适用，可在此手动指定。
@export
var scroll_container: ScrollContainer

## 自动滚动的最大速度。
@export 
var auto_scroll_speed := 10.0

## 自动滚动占空间的比例。
## [ScrollContainer]的高度为100像素，则上半部分将为0到30像素，下半部分将为70到100像素。
@export_range(0, 0.5) 
var auto_scroll_range := 0.3

## 滚动阈值，如果它太低，用户将很难拖动
@export 
var scroll_threshold := 30


var _scroll_starting_point := 0

var _drop_zones: Array[Rect2] = []
var _drop_zone_index := -1
# 预期布局矩形列表
var _expect_child_rect: Array[Rect2] = []

var _focus_child: Control
var _is_press := false
var _is_hold := false
# 当前持续时间
var _current_duration := 0.0
# 过度动画，控件会自动重新排序_on_sort_children
var _is_using_process := false


func _ready():
	# 获取ScrollContainer滚动框
	if scroll_container == null and get_parent() is ScrollContainer:
		scroll_container = get_parent()
	
	# 设置模式为暂停模式，这样就能计算子节点的布局
	# 否则实际运行时可能子节点的size为0
	process_mode = Node.PROCESS_MODE_PAUSABLE
	# 计算并设置子节点预期的布局矩形区域
	_adjust_expected_child_rect()
	# 监听子节点排序事件
	# CONNECT_PERSIST表示编辑器持久链接信号
	if not sort_children.is_connected(_on_sort_children):
		sort_children.connect(_on_sort_children, CONNECT_PERSIST)
	# node_added：当 node 进入该树时发出。
	if not get_tree().node_added.is_connected(_on_node_added):
		get_tree().node_added.connect(_on_node_added, CONNECT_PERSIST)

# 鼠标左键获取拖拽对象
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		for _child in get_children():
			var child := _child as Control
			if child.get_rect().has_point(get_local_mouse_position()) and event.is_pressed():
				_focus_child = child
				_is_press = true
			elif not event.is_pressed():
				_is_press = false
				_is_hold = false


func _process(delta):
	if Engine.is_editor_hint(): return	
	
	_handle_input(delta)
	# 时间超过hold_duration，则开始拖拽
	if _current_duration >= hold_duration != _is_hold:
		_is_hold = _current_duration >= hold_duration
		if _is_hold:
			_on_start_dragging()
	
	if _is_hold:
		_handle_dragging_child_pos(delta)
		if scroll_container != null:
			_handle_auto_scroll(delta)
	elif not _is_hold and _drop_zone_index != -1:
		_on_stop_dragging()

	# 自动排序
	if _is_using_process :
		_on_sort_children(delta)


func _handle_input(delta): 
	# 如果点击到了滚动框则获取开始位置
	if scroll_container != null and _is_press and not _is_hold:
		var scroll_point = scroll_container.scroll_vertical if is_vertical else scroll_container.scroll_horizontal
		# 当前持续时间
		if _current_duration == 0:
			_scroll_starting_point = scroll_point
		else:
			# 只有超出滚动阈值才能滚动
			_is_press = true if abs(scroll_point - _scroll_starting_point) <= scroll_threshold else false
	# 累计拖拽的时间
	_current_duration = _current_duration + delta if _is_press else 0.0


# 开始拖拽，并禁用其他子控件的点击
func _on_start_dragging():
	# 强制 _on_sort_children 使用 process 更新线性插值
	_is_using_process = true 
	_focus_child.z_index = 1
	for child in _get_visible_children():
		child.propagate_call("set_mouse_filter", [MOUSE_FILTER_IGNORE])


# 停止拖拽，并恢复其他子控件的点击
func _on_stop_dragging():
	if not _focus_child:
		return
	_focus_child.z_index = 0
	var focus_child_index := _focus_child.get_index()
	move_child(_focus_child, _drop_zone_index)
	reordered.emit(focus_child_index, _drop_zone_index)
	_focus_child = null
	_drop_zone_index = -1
	for child in _get_visible_children():
		child.propagate_call("set_mouse_filter", [MOUSE_FILTER_PASS])

# node_added当node进入该树时发出。
func _on_node_added(node):
	if node is Control and not Engine.is_editor_hint():
		node.mouse_filter = Control.MOUSE_FILTER_PASS


func _handle_dragging_child_pos(delta):
	# 与子控件自身拖拽有冲突
	"""
	if is_vertical:
		var target_pos = get_local_mouse_position().y - (_focus_child.size.y / 2.0)
		_focus_child.position.y = lerp(_focus_child.position.y, target_pos, delta * speed)
	else:
		var target_pos = get_local_mouse_position().x - (_focus_child.size.x / 2.0)
		_focus_child.position.x = lerp(_focus_child.position.x, target_pos, delta * speed)	
	"""

	# Update drop zone index
	var child_center_pos: Vector2 = _focus_child.get_rect().get_center()
	for i in range(_drop_zones.size()):
		var drop_zone = _drop_zones[i]
		if drop_zone.has_point(child_center_pos):
			_drop_zone_index = i
			break
		elif i == _drop_zones.size() - 1:
			_drop_zone_index = -1	


func _handle_auto_scroll(delta):
	var mouse_g_pos = get_global_mouse_position()
	var scroll_g_rect = scroll_container.get_global_rect()
	if is_vertical:
		var upper = scroll_g_rect.position.y + (scroll_g_rect.size.y * auto_scroll_range)
		var lower = scroll_g_rect.position.y + (scroll_g_rect.size.y * (1.0 - auto_scroll_range))
		
		if upper > mouse_g_pos.y:
			var factor = (upper - mouse_g_pos.y) / (upper - scroll_g_rect.position.y)
			scroll_container.scroll_vertical -= delta * float(auto_scroll_speed) * 150.0 * factor
		elif lower < mouse_g_pos.y:
			var factor = (mouse_g_pos.y - lower) / (scroll_g_rect.end.y - lower)
			scroll_container.scroll_vertical += delta * float(auto_scroll_speed) * 150.0 * factor
		else:
			scroll_container.scroll_vertical = scroll_container.scroll_vertical
	else:
		var left = scroll_g_rect.position.x + (scroll_g_rect.size.x * auto_scroll_range)
		var right = scroll_g_rect.position.x + (scroll_g_rect.size.x * (1.0 - auto_scroll_range))
		
		if left > mouse_g_pos.x:
			var factor = (left - mouse_g_pos.x) / (left - scroll_g_rect.position.x)
			scroll_container.scroll_horizontal -= delta * float(auto_scroll_speed) * 150.0 * factor
		elif right < mouse_g_pos.x:
			var factor = (mouse_g_pos.x - right) / (scroll_g_rect.end.x - right)
			scroll_container.scroll_horizontal += delta * float(auto_scroll_speed) * 150.0 * factor
		else:
			scroll_container.scroll_horizontal = scroll_container.scroll_horizontal		


func _on_sort_children(delta := -1.0):
	if _is_using_process and delta == -1.0:
		return
	
	_adjust_expected_child_rect()
	_adjust_child_rect(delta)
	_adjust_drop_zone_rect()

# 计算并设置子节点预期的布局矩形区域
func _adjust_expected_child_rect():
	# 清空预期布局矩形列表
	_expect_child_rect.clear()
	# 获取可见子节点
	var children := _get_visible_children()
	var end_point = 0.0
	for i in range(children.size()):
		var child := children[i]
		# 计算子节点最小尺寸
		var min_size := child.get_combined_minimum_size()
		if is_vertical:
			if i == _drop_zone_index:
				end_point += _focus_child.size.y + separation
			
			_expect_child_rect.append(Rect2(Vector2(0, end_point), Vector2(size.x, min_size.y)))
			end_point += min_size.y + separation
		else:
			if i == _drop_zone_index:
				end_point += _focus_child.size.x + separation
			
			_expect_child_rect.append(Rect2(Vector2(end_point, 0), Vector2(min_size.x, size.y)))
			end_point += min_size.x + separation
			
# 调整子节点的位置和大小至期望值
func _adjust_child_rect(delta: float = -1.0):
	# 获取可见子节点
	var children := _get_visible_children()
	if children.is_empty():
		return
	
	#检查是否需动画过渡
	var is_animating := false
	var end_point := 0.0
	for i in range(children.size()):
		var child := children[i]
		if child.position == _expect_child_rect[i].position and child.size == _expect_child_rect[i].size:
			continue
		# 逐个调整子节点位置和大小，若使用动画则平滑过渡。
		if _is_using_process:
			is_animating = true
			child.position = lerp(child.position, _expect_child_rect[i].position, delta * speed)
			child.size = _expect_child_rect[i].size
			if (child.position - _expect_child_rect[i].position).length() <= 1.0:
				child.position = _expect_child_rect[i].position
		else:
			child.position = _expect_child_rect[i].position
			child.size = _expect_child_rect[i].size
	
	var last_child := children[-1]
	if is_vertical:
		# 更新最小尺寸以适应最后一个子节点
		if _is_using_process and _drop_zone_index == children.size():
			custom_minimum_size.y = _expect_child_rect[-1].end.y + _focus_child.size.y + separation
		elif not _is_using_process:
			custom_minimum_size.y = last_child.get_rect().end.y
	else:
		if _is_using_process and _drop_zone_index == children.size():
			custom_minimum_size.x = _expect_child_rect[-1].end.x + _focus_child.size.x + separation
		elif not _is_using_process:
			custom_minimum_size.x = last_child.get_rect().end.x

	# Adjust rect every process frame until child is dropped and finished lerping 
	# ( return to adjust when sort_children signal is emitted)
	if not is_animating and _focus_child == null:
		_is_using_process = false

# 根据子控件的位置和大小动态调整拖放区域（drop zones）
func _adjust_drop_zone_rect():
	_drop_zones.clear()
	var children = _get_visible_children()
	for i in range(children.size()):
		var drop_zone_rect: Rect2
		var child := children[i] as Control
		if is_vertical:
			if i == 0:
				# 第一个子节点上方创建拖放区域。
				drop_zone_rect.position = Vector2(child.position.x, child.position.y - DROP_ZONE_EXTEND)
				drop_zone_rect.end = Vector2(child.size.x, child.get_rect().get_center().y)
				_drop_zones.append(drop_zone_rect)
			else:
				# 中间子节点之间创建拖放区域。
				var prev_child := children[i - 1] as Control
				drop_zone_rect.position = Vector2(prev_child.position.x, prev_child.get_rect().get_center().y)
				drop_zone_rect.end = Vector2(child.size.x, child.get_rect().get_center().y)
				_drop_zones.append(drop_zone_rect)
			if i == children.size() - 1:
				# 最后一个子节点下方创建拖放区域。
				drop_zone_rect.position = Vector2(child.position.x, child.get_rect().get_center().y)
				drop_zone_rect.end = Vector2(child.size.x, child.get_rect().end.y + DROP_ZONE_EXTEND)
				_drop_zones.append(drop_zone_rect)
		else:
			if i == 0:
				# 第一个子节点左边创建拖放区域。
				drop_zone_rect.position = Vector2(child.position.x - DROP_ZONE_EXTEND, child.position.y)
				drop_zone_rect.end = Vector2(child.get_rect().get_center().x, child.size.y)
				_drop_zones.append(drop_zone_rect)
			else:
				# 中间子节点之间创建拖放区域
				var prev_child := children[i - 1] as Control
				drop_zone_rect.position = Vector2(prev_child.get_rect().get_center().x, prev_child.position.y)
				drop_zone_rect.end = Vector2(child.get_rect().get_center().x, child.size.y)
				_drop_zones.append(drop_zone_rect)
			if i == children.size() - 1:
				# 最后一个子节点右边创建拖放区域。
				drop_zone_rect.position = Vector2(child.get_rect().get_center().x, child.position.y)
				drop_zone_rect.end = Vector2(child.get_rect().end.x + DROP_ZONE_EXTEND, child.size.y)
				_drop_zones.append(drop_zone_rect)


# 返回所有显示的子控件，不包括拖拽中的控件
func _get_visible_children() -> Array[Control]:
	var visible_control: Array[Control]
	for _child in get_children():
		var child := _child as Control
		if not child.visible:
			continue
		if child == _focus_child and _is_hold:
			continue
		
		visible_control.append(child)
	return visible_control

func remove_drop(target):
	_on_stop_dragging()
	_is_press = false
	_is_hold = false
	_focus_child = null
	self.remove_child(target)
	
func add_drop(target):
	self.add_child(target)
	_focus_child = target
	_on_stop_dragging()

# 倒序删除所有子节点
func remove_all_child():
	_is_press = false
	_is_hold = false
	_focus_child = null
	while get_child_count() > 0:
		remove_child(get_child(0))
