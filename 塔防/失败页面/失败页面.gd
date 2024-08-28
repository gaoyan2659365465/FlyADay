class_name 失败页面 extends Control


func _on_button确认_点击动画结束() -> void:
	get_tree().paused = false
	# 返回游戏主界面
	get_tree().change_scene_to_file("res://gamelevel/game_level.tscn")
	# 需要加金币
	var zydx = preload("res://获取资源动效/获取资源动效.tscn").instantiate()
	zydx.设置图标(preload("res://塔防/resource/测试/icon_jz.png"))
	zydx.设置目标位置(Vector2(805,42))
	Global.umg.add_child(zydx)
	zydx.position = Vector2(1152,648)/2
	
	Global.player_save.金币 += 15
	Global.saveResource()
