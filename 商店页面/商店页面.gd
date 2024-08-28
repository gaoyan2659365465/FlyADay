class_name 商店页面 extends Control


func _ready() -> void:
	var sp_1 = $"HBoxContainer/一点金币"
	sp_1.修改样式("金色")
	var sp_1_tex = preload("res://塔防/resource/测试/icon_jz.png")
	sp_1.初始化信息("一点金币", sp_1_tex, 500, "免费按钮", 0)
	
	var sp_2 = $"HBoxContainer/一袋金币"
	sp_2.修改样式("金色")
	sp_2.初始化信息("一袋金币", sp_1_tex, 2000, "钻石按钮", 400)
	
	var sp_3 = $"HBoxContainer/一箱金币"
	sp_3.修改样式("金色")
	sp_3.初始化信息("一箱金币", sp_1_tex, 10000, "钻石按钮", 1200)
	
	var sp_4 = $"HBoxContainer2/一点钻石"
	sp_4.修改样式("蓝色")
	var sp_4_tex = preload("res://塔防/resource/测试/icon_bcs05.png")
	sp_4.初始化信息("钻石", sp_4_tex, 150, "免费按钮", 0)
	
	var sp_5 = $"HBoxContainer2/随机商品1"
	var sp_6 = $"HBoxContainer2/随机商品2"
	var sp_7 = $"HBoxContainer2/随机商品3"
	var sp_8 = $"HBoxContainer2/随机商品4"
	
	var sps = [sp_5, sp_6, sp_7, sp_8]
	var wp_data = Global.excel_data.根据等级获取物品(1)
	for i in sps:
		i.修改样式("蓝色")
		var _id = randi_range(0,wp_data.size()-1)
		var w = wp_data[_id]
		var _name = w[1]
		var _tex = load(w[2])
		var _n = randi_range(3,5)
		var _p = randi_range(13,54)
		var _bt_type = "金币按钮"
		if i == sp_7 or i == sp_8:
			_bt_type = "钻石按钮"
		i.初始化信息(_name, _tex, _n, _bt_type, _p)
		i.显示打折(randi_range(5,9))
	


func _on_button刷新_点击动画结束() -> void:
	_ready()


func _on_button关闭_点击动画结束() -> void:
	queue_free()
