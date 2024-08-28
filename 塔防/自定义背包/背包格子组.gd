class_name 背包格子组 extends Control

"""
当退出背包编辑模式后，根据编辑的结果，给格子组添加或减少新格子，并删除<拖拽格子组>
并且接管所有背包中的物品
当进入背包编辑模式时，格子组能在背包中整体移动，但是不能离开背包
"""
@onready var 背景: Panel = $"背景"
@onready var drag_item: Panel = $"拖拽格子"


# 计算偏移
var h_separation = 5
var v_separation = 5

var 格子表 = []


# 根据背包中的二维数组创建格子
func 创建格子():
	for i in 格子表:
		remove_child(i[1])
	格子表.clear()
	
	var p:自定义背包 = get_parent()
	var index_list = p.core.get_index_list(1)
	for i in index_list:
		var x = i%p.core.width
		var y = i/p.core.width
		var tzgz:Panel = drag_item.duplicate()
		var flat = tzgz.get("theme_override_styles/panel").duplicate()
		tzgz.set("theme_override_styles/panel",flat)
		
		add_child(tzgz)
		tzgz.visible = true
		格子表.append([i,tzgz])
		tzgz.position = Vector2(x*tzgz.size.x + x*h_separation,\
								 y*tzgz.size.y + y*v_separation)
	计算尺寸()




func 计算尺寸():
	$"背景".visible = true
	var offset = 10
	var x = 9999
	var y = 9999
	var w = 0
	var h = 0
	for i in 格子表:
		if x > i[1].position.x:
			x = i[1].position.x
		if y > i[1].position.y:
			y = i[1].position.y
		if w < i[1].position.x:
			w = i[1].position.x + i[1].size.x
		if h < i[1].position.y:
			h = i[1].position.y + i[1].size.x
	背景.position = Vector2(x-offset,y-offset)
	背景.size = Vector2(w-x+offset*2,h-y+offset*2)

func 隐藏背景():
	$"背景".visible = false

func 根据合法性染色(legal):
	var 绿格子:Color = Color(0, 0.482, 0)
	var 红格子:Color = Color(0.514, 0, 0)
	for i in legal[1]:
		var target = 获取格子(i)
		if target:
			var panel = target.get("theme_override_styles/panel")
			var color = 绿格子
			if not legal[0]:
				color = 红格子
			panel.set("bg_color",color)

func 获取格子(index):
	for i in 格子表:
		if i[0] == index:
			return i[1]
	return null

func 清空颜色():
	for i in 格子表:
		var 默认颜色:Color = Color(0.745, 0.506, 1)
		var panel = i[1].get("theme_override_styles/panel")
		panel.set("bg_color",默认颜色)
