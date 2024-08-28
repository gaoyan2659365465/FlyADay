class_name 引导场景 extends Control



func _ready() -> void:
	引导对话1()


func 引导对话1():
	var yd = preload("res://引导/引导对话框.tscn").instantiate()
	self.add_child(yd)
	yd.设置内容("怪物大军即将到来，赶快布置水果勇士，准备迎战吧！")
	yd.position = Vector2(0,0)
	
	var xyb = preload("res://引导/进入下一步.tscn").instantiate()
	self.add_child(xyb)
	# 玩家点击屏幕时销毁
	xyb.玩家点击.connect(func():
		yd.queue_free()
		引导对话2())
	
func 引导对话2():
	var zz = preload("res://引导/引导遮罩.tscn").instantiate()
	self.add_child(zz)
	zz.initMask(Rect2(Vector2(874,132),Vector2(137,74)))
	zz.过渡动画()
	# 当某个信号被触发以后应该关闭引导遮罩，进入下一阶段
	
	var yd = preload("res://引导/引导对话框.tscn").instantiate()
	self.add_child(yd)
	yd.设置内容("将商店中刷新出的装备放置到背包")
	yd.position = Vector2(0,-100)
	

func 引导对话3():
	var yd = preload("res://引导/引导对话框.tscn").instantiate()
	self.add_child(yd)
	yd.设置内容("刷新商店获得更多水果")
	yd.position = Vector2(0,0)
