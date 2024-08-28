class_name 自定义背包 extends Control


@onready var grid_container: GridContainer = $Panel/MarginContainer/GridContainer
@onready var 拖拽框: ReorderableContainer = $ReorderableContainer
@onready var 背包格子: 背包格子组 = $"背包格子组"
@onready var _物品生成器: 物品生成器 = $"物品生成器"


@export var grid_size:Vector2i = Vector2i(5,7)

# 用于放置格子
var core:背包核心
# 用于格子中的物品
var core_item:背包核心

# 进入编辑模式
var 编辑模式:bool = false:
	set(value):
		编辑模式 = value
		self.设置背包编辑模式()

signal 开始战斗
signal 刷新道具

func _ready() -> void:
	self.core_item = 背包核心.new()
	self.core_item.create_data(5,7)
	self.core = 背包核心.new()
	self.core.create_data(5,7)
	# 初始化中间9个格子
	for i in range(1,4):
		for j in range(2,5):
			self.core.grid_data[i][j] = 1
	
	创建格子()
	背包格子.创建格子()
	self.编辑模式 = false
	# 显示黑色背景
	$ColorRect.visible = true


func 创建格子():
	for i in range(grid_size.x*grid_size.y):
		var gz = preload("res://塔防/自定义背包/格子.tscn").instantiate()
		grid_container.add_child(gz)
	
# 清空所有格子颜色
func clearColor():
	for i:格子 in grid_container.get_children():
		i.格子状态 = "虚格子"
	背包格子.清空颜色()


# 获取距离最近的格子
func get_nearest_grid(pos:Vector2):
	var _min_d = 9999
	var target
	for i:格子 in grid_container.get_children():
		var d = pos.distance_to(i.global_position)
		if d < _min_d:
			_min_d = d
			target = i
	return target

# 判断绝对位置是否处于背包中
func is_absolute_position(pos:Vector2):
	var _rect = grid_container.get_rect()
	_rect.position = grid_container.global_position
	return _rect.has_point(pos)

func _on_拖拽格子组_拖拽开始(target: Variant) -> void:
	self.core.remove_item(target)
	# 拖拽任意格子就进入编辑模式
	self.编辑模式 = true

func _on_拖拽格子组_正在拖拽(target) -> void:
	# 清空所有格子颜色
	clearColor()
	# 判断是否处于背包区域内
	if not is_absolute_position(target.global_position):
		self.core.legal = [false]
		return
	
	# 获取最近的格子,获取索引,用来当做偏移
	var _offset = get_nearest_grid(target.global_position).get_index()
	
	# 判断合法性，是否处于边缘位置导致一部分格子在背包外
	self.core.check_legal(target, target.格子形状, _offset)
	
	# 获取相应的引用,并根据合法性染色
	for i in self.core.legal[1]:
		var g:格子 = grid_container.get_child(i)
		g.临时改变颜色(self.core.legal[0])

func _on_拖拽格子组_拖拽完毕(target) -> void:
	clearColor()
	if self.core.legal[0]:
		# 如果物品当前处于拖拽框，则拿出子项，并赋予其他父项
		if target.get_parent() == 拖拽框:
			移动物品(target,0)
		var i = get_nearest_grid(target.global_position)
		target.吸附动画(i.global_position)
	else:
		if target.get_parent() != 拖拽框:
			移动物品(target,1)
		else:
			拖拽框._on_stop_dragging()
		return
	self.core.add_item(target)

# 从拖拽框跟背包自由移动，会修改树结构
func 移动物品(target,type):
	if type == 0:
		# 记录位置因为修改树会丧失位置信息
		var p = target.global_position
		拖拽框.remove_drop(target)
		self.add_child(target)
		target.global_position = p
	elif type == 1:
		var p = target.global_position
		self.remove_child(target)
		拖拽框.add_drop(target)
		target.global_position = p
	target.size = Vector2.ZERO

func _on_背包物品_拖拽开始(target: Variant) -> void:
	self.core_item.remove_item(target)

func _on_背包物品_拖拽完毕(target: Variant) -> void:
	clearColor()
	if self.core_item.legal[0]:
		# 如果物品当前处于拖拽框，则拿出子项，并赋予其他父项
		if target.get_parent() == 拖拽框:
			移动物品(target,0)
		var i = get_nearest_grid(target.global_position)
		target.吸附动画(i.global_position)
	else:
		if target.get_parent() != 拖拽框:
			移动物品(target,1)
		else:
			拖拽框._on_stop_dragging()
		return
	
	# 合成必须物品相同，位置完全相同
	# 如果位置不同则弹出物品
	
	# 获取当前拖拽中的物品所在的格子中有没有其他的物品
	var items = self.core_item.get_item()
	# 弹出所有物品
	for i in items:
		self.core_item.remove_item(i)
		移动物品(i,1)
	
	self.core_item.add_item(target)
	

func _on_背包物品_正在拖拽(target: Variant) -> void:
	# 清空所有格子颜色
	clearColor()
	# 防止拖拽物尺寸过大，使用最小尺寸
	target.size = Vector2.ZERO
	
	# 判断是否处于背包区域内
	if not is_absolute_position(target.global_position):
		self.core_item.legal = [false]
		return
	
	# 获取最近的格子,获取索引,用来当做偏移
	var _offset = get_nearest_grid(target.global_position).get_index()
	
	# 判断合法性，是否处于边缘位置导致一部分格子在背包外
	var _value = self.core.check_legal(target, target.格子形状, _offset)
	
	self.core_item.check_legal(target, target.格子形状, _offset)
	# 希望把之前的物品挤出来，所以默认为true
	self.core_item.legal[0] = true
	
	# 非法格子数如果与最大格子数不同，相当于物品大于单个格子
	if _value[1].size() - _value[2].size() != 背包核心.get_lattic(target.格子形状).size():
		self.core_item.legal[0] = false
	
	# 获取相应的引用,并根据合法性染色
	背包格子.根据合法性染色(self.core_item.legal)


func 设置背包编辑模式():
	if self.编辑模式:
		# 显示背包背景板
		$Panel.modulate = Color(1,1,1,1)
		背包格子.隐藏背景()
		# 显示确定按钮
		$"Button确定".visible = true
		# 隐藏其他按钮
		$"按钮栏".visible = false
		# 显示提示文字"将格子放好后确认"
		$"文字提示".visible = true
		# 物品置为不可拖拽模式，并且半透明
		for i in get_children():
			if i as 背包物品:
				i.禁用拖拽(true)
		var reo = $ReorderableContainer
		for i in reo.get_children():
			if i as 背包物品:
				i.禁用拖拽(true)
	else:
		# 隐藏背包背景板
		$Panel.modulate = Color(1,1,1,0)
		# 删除所有拖拽格子
		for i in self.core.target_list:
			i[0].queue_free()
		self.core.target_list = []
		背包格子.创建格子()
		# 隐藏确定按钮
		$"Button确定".visible = false
		# 显示其他按钮
		$"按钮栏".visible = true
		# 隐藏提示文字"将格子放好后确认"
		$"文字提示".visible = false
		# 物品置为可拖拽模式，并且不透明
		for i in get_children():
			if i as 背包物品:
				i.禁用拖拽(false)
		var reo = $ReorderableContainer
		for i in reo.get_children():
			if i as 背包物品:
				i.禁用拖拽(false)

func 结束战斗():
	# 显示黑色背景
	$ColorRect.visible = true
	# 生成三个道具到物品栏
	$"物品生成器".创建物品()
	# 允许物品拖拽
	# 锁定物品攻击
	for i in get_children():
		if i as 背包物品:
			i.开启战斗(false)
	# 显示按钮栏
	$"按钮栏".visible = true

# 配置完毕开始战斗
func _on_button开战_点击动画结束() -> void:
	# 隐藏黑色背景
	$ColorRect.visible = false
	# 隐藏其他按钮
	$"按钮栏".visible = false
	# 删除物品栏的所有道具
	$ReorderableContainer.remove_all_child()
	# 通知关卡开始刷怪
	emit_signal("开始战斗")
	# 禁止物品拖拽
	# 物品开始攻击
	for i in get_children():
		if i as 背包物品:
			i.开启战斗(true)


# 点击确认后退出背包编辑模式
func _on_button确定_点击动画结束() -> void:
	self.编辑模式 = false

# 消耗15银币删除所有物品栏物品并且重新创建3个新物品
func _on_button刷新_点击动画结束() -> void:
	var p:塔防关卡 = get_parent()
	if p.银币 < 15:
		# 需要弹出提示“银币不足”
		return
	# 消耗银币
	emit_signal("刷新道具")
	# 删除物品栏的所有道具
	$ReorderableContainer.remove_all_child()
	# 重新创建物品
	_物品生成器.创建物品()
	
