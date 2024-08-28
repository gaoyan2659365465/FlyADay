class_name 拖拽格子组 extends 拖拽物


"""
鼠标点击拖拽
很多个能拖拽格子的组合，比如鼠标一次性拖拽3个格子
"""

@onready var drag_item: Panel = $"拖拽格子"


# 定位格子列表
var pos = []
@export var 格子形状:背包核心.LATTICLE_SHAPE
# 计算偏移
var h_separation = 5
var v_separation = 5


func _ready() -> void:
	super._ready()
	pos = 背包核心.get_lattic(格子形状)
	self.create_drag_item()
	self.size = 根据格子计算尺寸()
	self.custom_minimum_size = self.size

# 创建格子
func create_drag_item():
	for i in pos:
		var tzgz:Panel = drag_item.duplicate()
		add_child(tzgz)
		tzgz.visible = true
		tzgz.position = Vector2(i[0]*tzgz.size.x + i[0]*h_separation,\
								 i[1]*tzgz.size.y + i[1]*v_separation)
		
func 根据格子计算尺寸():
	var max_x = 0
	var max_y = 0
	var _size = Vector2(54,54)
	for i in pos:
		if i[0] > max_x:
			max_x = i[0]
		if i[1] > max_y:
			max_y = i[1]
	return Vector2((max_x+1)*_size.x + max_x*h_separation,\
					(max_y+1)*_size.y + max_y*v_separation)
