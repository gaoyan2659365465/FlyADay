class_name ExcelData extends Node

"""
# 获取数据
self.json.data['数据表名']
"""

# 用于加载Json数据
var json

func _init() -> void:
	self.json = preload("res://塔防/数据表/游戏数据表.json")
	pass




func 根据章节和波数获取敌人数据(_zj, _bs):
	var data = self.json.data['关卡敌人配置']
	for key in data:
		if data[key]["章节"] == _zj:
			if data[key]["波数"] == _bs:
				return [data[key]["敌人_1_ID"], data[key]["敌人_1_数量"],\
						data[key]["敌人_2_ID"], data[key]["敌人_2_数量"],\
						data[key]["敌人_3_ID"], data[key]["敌人_3_数量"]]
				
func 根据章节和波数获取出怪顺序(_zj, _bs):
	var data = self.json.data['出怪顺序']
	var bz = []
	for key in data:
		if data[key]["章节"] == _zj:
			if data[key]["波数"] == _bs:
				bz.append([data[key]["出怪步骤"], data[key]["敌人ID"], data[key]["数量"], data[key]["间隔时间"]])
	return bz

func 根据章节获取最大波数(_zj):
	var data = self.json.data['章节配置']
	for key in data:
		if data[key]["章节"] == _zj:
			return [data[key]["最大波数"]]


func 根据等级获取物品(_lv):
	var data = self.json.data['物品']
	var wp = []
	for key in data:
		if data[key]["等级"] == _lv:
			wp.append([data[key]["ID"], data[key]["物品名称"],\
			 data[key]["图片路径"], data[key]["格子形状"],\
			 data[key]["等级"], data[key]["攻击"],\
			 data[key]["冷却"], data[key]["目标"], data[key]["技能"]])
	return wp

func 根据等级获取所需经验(_lv):
	var data = self.json.data['等级经验']
	for key in data:
		if data[key]["等级"] == _lv:
			return [data[key]["所需经验"]]
