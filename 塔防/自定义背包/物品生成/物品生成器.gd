class_name 物品生成器 extends Node


"""
回合结束以后生成一些物品到背包的准备栏中
创建3个，格子或道具根据比例随机创建
点击刷新可以消耗银币刷新
"""

@export var 物品栏:ReorderableContainer
@export var 背包:自定义背包

func _ready() -> void:
	# 等待一帧，确保某些东西被加载
	await get_tree().process_frame
	创建物品()

func 创建物品():
	var wp_data = Global.excel_data.根据等级获取物品(1)
	
	for i in range(3):
		var r = randi_range(0,100)
		if r < 20:
			var gz = preload("res://塔防/自定义背包/拖拽物/拖拽格子组.tscn").instantiate()
			gz.格子形状 = randi_range(0,9)
			物品栏.add_child(gz)
			gz.connect("拖拽开始",背包._on_拖拽格子组_拖拽开始)
			gz.connect("拖拽完毕",背包._on_拖拽格子组_拖拽完毕)
			gz.connect("正在拖拽",背包._on_拖拽格子组_正在拖拽)
		else:
			var wp = preload("res://塔防/自定义背包/拖拽物/背包物品.tscn").instantiate()
			物品栏.add_child(wp)
			var wp_id = randi_range(0,wp_data.size()-1)
			wp.init_item_data(wp_data[wp_id])
			wp.connect("拖拽开始",背包._on_背包物品_拖拽开始)
			wp.connect("拖拽完毕",背包._on_背包物品_拖拽完毕)
			wp.connect("正在拖拽",背包._on_背包物品_正在拖拽)
		
		
