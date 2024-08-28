class_name 背包核心 extends RefCounted

"""
传进来的都是一维索引
传出去的都是一维索引
"""
var width:int = 0
var height:int = 0
var grid_data = []
var target_list = []
var legal = []

# 格子形状

enum LATTICLE_SHAPE {
	点一,
	横二,
	竖二,
	横三,
	竖三,
	田字型,
	三角左,
	三角右,
	倒三角左,
	倒三角右
}


# 创建背包数据
func create_data(w:int, h:int):
	width = w
	height = h
	grid_data = []
	for i in range(w):
		grid_data.append([])
		for j in range(h):
			grid_data[i].append(0)


# 根据数据值获取索引列表
func get_index_list(value:int):
	var index_list = []
	for i in range(width):
		for j in range(height):
			if grid_data[i][j] == value:
				index_list.append(j * width + i)
	return index_list


# 放入物品到target_list,需要目标位置格子的一维索引
# 需要先进行合法性检测
func add_item(target:Node):
	var new_pos = []
	for i in self.legal[1]:
		grid_data[i%width][i/width] = 1
		new_pos.append([i%width, i/width])
	
	target_list.append([target, new_pos])
	return true


# 移除物品
func remove_item(target:Node):
	var n = 0
	for i in target_list:
		if i[0] == target:
			for j in i[1]:
				grid_data[j[0]][j[1]] = 0
			target_list.remove_at(n)
			return true
		n+=1
	return false

# 合法性检测 返回所有非法索引
func check_legal(target:Node, shape:LATTICLE_SHAPE, index:int):
	var _validity = true
	var pos = get_lattic(shape)

	# 一维索引转二维索引
	var _index = [index%width, index/width]
	# 需要检查超出索引情况
	var new_pos = []
	for i in pos:
		var x = i[0] + _index[0]
		var y = i[1] + _index[1]
		if x >= width or y >= height:
			_validity = false
			continue
		new_pos.append([x, y])
	
	# 二维索引转一维索引
	var all_index = []
	var validity_index = []
	for i in new_pos:
		all_index.append(i[1] * width + i[0])
		if grid_data[i[0]][i[1]] == 0:
			validity_index.append(i[1] * width + i[0])
		else:
			_validity = false
	

	self.legal = [_validity,all_index,validity_index]
	return self.legal

# 获取指定格子组中的n个物品
func get_item():
	var item_list = []
	for t in target_list:
		# 是否找到
		var _find = false
		for j in t[1]:
			for i in self.legal[1]:
				if j == [i%width,i/width]:
					item_list.append(t[0])
					_find = true
					break
			if _find:
				break
	return item_list

# 获取格子形状列表
static func get_lattic(type:LATTICLE_SHAPE):
	if type == LATTICLE_SHAPE.点一:
		return [[0,0]]
	elif type == LATTICLE_SHAPE.横二:
		return [[0,0],[1,0]]
	elif type == LATTICLE_SHAPE.竖二:
		return [[0,0],[0,1]]
	elif type == LATTICLE_SHAPE.横三:
		return [[0,0],[1,0],[2,0]]
	elif type == LATTICLE_SHAPE.竖三:
		return [[0,0],[0,1],[0,2]]
	elif type == LATTICLE_SHAPE.田字型:
		return [[0,0],[1,0],[0,1],[1,1]]
	elif type == LATTICLE_SHAPE.三角左:
		return [[0,0],[0,1],[1,1]]
	elif type == LATTICLE_SHAPE.三角右:
		return [[0,1],[1,0],[1,1]]
	elif type == LATTICLE_SHAPE.倒三角左:
		return [[0,0],[0,1],[1,0]]
	elif type == LATTICLE_SHAPE.倒三角右:
		return [[0,0],[1,0],[1,1]]
