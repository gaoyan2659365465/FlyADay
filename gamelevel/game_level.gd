class_name GameLevel extends Control


# 新的一天第一次进入的时候刷新体力
func _ready() -> void:
	if not 今天是否刷新体力():
		Global.player_save.体力 = 30
		Global.player_save.刷新体力时间 = Time.get_date_dict_from_system()
		Global.saveResource()

func 今天是否刷新体力():
	var time = Time.get_date_dict_from_system()
	var 刷新体力时间 = Global.player_save.刷新体力时间
	if 刷新体力时间 == time:
		return true
	return false


func _on_button扫荡_点击动画结束() -> void:
	# 消耗体力
	if Global.player_save.体力 < 5:
		print("体力不足")
		return
	Global.player_save.体力 -= 5
	
	var wp = preload("res://获得物品页面/获得物品页面.tscn").instantiate()
	add_child(wp)
	await wp.点击领取
	var zydx = preload("res://获取资源动效/获取资源动效.tscn").instantiate()
	zydx.设置图标(preload("res://塔防/resource/测试/icon_bcs05.png"))
	zydx.设置目标位置(Vector2(942,44))
	add_child(zydx)
	zydx.position = size/2
	
	# 增加钻石
	await get_tree().create_timer(1.0).timeout
	Global.player_save.钻石 += 100
	Global.saveResource()

func _on_button开始_点击动画结束() -> void:
	# 消耗体力
	if Global.player_save.体力 < 5:
		print("体力不足")
		return
	Global.player_save.体力 -= 5
	
	# 游戏开始时重置经验和等级
	Global.player_save.等级 = 1
	Global.player_save.经验值 = 0
	
	# 需要确定当前选择的关卡为第几章
	Global.player_save.第几章 = $"左右换图页面".当前页 + 1
	get_tree().change_scene_to_file("res://塔防/塔防关卡.tscn")


func _on_button商店_点击动画结束() -> void:
	var sd = preload("res://商店页面/商店页面.tscn").instantiate()
	add_child(sd)
