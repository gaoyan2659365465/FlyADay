class_name 胜利页面 extends Control




func _on_button确认_点击动画结束() -> void:
	get_tree().change_scene_to_file("res://gamelevel/game_level.tscn")
	
	var zydx = preload("res://获取资源动效/获取资源动效.tscn").instantiate()
	zydx.设置图标(preload("res://resource/金币图标.png"))
	zydx.设置目标位置(Vector2(805,42))
	Global.umg.add_child(zydx)
	zydx.position = Vector2(1152,648)/2
	
	var zydx2 = preload("res://获取资源动效/获取资源动效.tscn").instantiate()
	zydx2.设置图标(preload("res://塔防/resource/测试/icon_bcs05.png"))
	zydx2.设置目标位置(Vector2(947,42))
	Global.umg.add_child(zydx2)
	zydx2.position = Vector2(1152,648)/2
	
	var zydx3 = preload("res://获取资源动效/获取资源动效.tscn").instantiate()
	zydx3.设置图标(preload("res://数值显示控件/resource/体力图标.png"))
	zydx3.设置目标位置(Vector2(665,42))
	Global.umg.add_child(zydx3)
	zydx3.position = Vector2(1152,648)/2
	
	Global.player_save.金币 += 100
	Global.player_save.钻石 += 50
	Global.player_save.体力 += 5
	Global.saveResource()
