class_name 背包物品 extends 拖拽物


@export var 格子形状:背包核心.LATTICLE_SHAPE
@onready var timer: Timer = $Timer
@onready var texture_rect: TextureRect = $TextureRect


# 物品数据，从表中读取
var item_data

func _ready() -> void:
	super._ready()
	

# 初始化物品数据
func init_item_data(data:Array):
	self.item_data = data
	# 初始化格子形状
	var id = 背包核心.LATTICLE_SHAPE.keys().find(data[3])
	格子形状 = 背包核心.LATTICLE_SHAPE.values()[id]
	# 冷却时间
	timer.wait_time = data[6]
	# 初始化图片
	var img = load(data[2])
	texture_rect.texture = img
	# 创建一个技能
	$AbilitySystem.create_ability(data[8])

# 禁用物品拖拽
func 禁用拖拽(value:bool):
	if value:
		# 使物品透明
		self.modulate = Color(1,1,1,0.5)
		# 断开连接
		if gui_input.is_connected(_on_gui_input):
			gui_input.disconnect(_on_gui_input)
	else:
		# 使物品透明
		self.modulate = Color(1,1,1,1)
		# 重新连接
		if not gui_input.is_connected(_on_gui_input):
			gui_input.connect(_on_gui_input)

func 图片攻击缩放动画():
	self.pivot_offset = self.size/2
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1.1,1.1),0.1)
	tween.tween_property(self,"scale",Vector2(1.0,1.0),0.2)
	# 如果冷却很小，则失去动画效果


func _on_timer_timeout() -> void:
	图片攻击缩放动画()
	# 运行带有"平A"标签的技能
	$AbilitySystem.try_activate_abilities_by_tag("攻击")

# 由背包统一调用，设置当前物品的状态是否为战斗
func 开启战斗(value:bool):
	if value:
		timer.start()
	else:
		timer.stop()
