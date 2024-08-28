class_name 签到页面 extends Control


@onready var grid_container: GridContainer = $GridContainer

"""
使用签到系统需要在Global中的player_save中写入sign_in_data变量

# 当前已签到多少天
@export var sign_in_days = 0
# 签到数据
@export var sign_in_data = []


"""
var 当天签到子项

signal 关闭签到页面

func _on_弹窗_关闭弹窗() -> void:
	self.关闭签到页面.emit()
	queue_free()


func _ready():
	# 删除示例分组的子项
	for i in range(10):
		grid_container.remove_child(grid_container.get_child(0))
	
	# 如果今天已经签到就不再显示按钮
	var qd = 今天是否签到()
	if qd:
		$"Button领取奖励".visible = false
		$"Button双倍奖励".visible = false
		$Label.visible = true
	
	# 查看当前签到多少天
	var day = Global.player_save.sign_in_days
	# 动态添加子项
	for i in range(10):
		var item = preload("res://签到页面/签到子项.tscn").instantiate()
		grid_container.add_child(item)
		item.设置文字(i+1)
		if i < day:
			item.领取变黑()
		elif i == day:
			# 先存一下备用
			当天签到子项 = item
			if not qd:
				item.高亮()
		else:
			pass


func 今天是否签到():
	var time = Time.get_date_dict_from_system()
	var sign_in_data = Global.player_save.sign_in_data
	for i in sign_in_data:
		if i == time:
			return true
	return false



func _on_button领取奖励_点击动画结束() -> void:
	var time = Time.get_date_dict_from_system()
	Global.player_save.sign_in_data.append(time)
	# 存档中签到天数加1
	Global.player_save.sign_in_days = Global.player_save.sign_in_days + 1
	Global.saveResource()
	当天签到子项.领取变黑()
	$"Button领取奖励".visible = false
	$"Button双倍奖励".visible = false
	$Label.visible = true
	
	var zydx = preload("res://获取资源动效/获取资源动效.tscn").instantiate()
	zydx.设置图标(preload("res://塔防/resource/测试/icon_bcs05.png"))
	zydx.设置目标位置(Vector2(944,42))
	Global.umg.add_child(zydx)
	zydx.position = Vector2(1152,648)/2
	await get_tree().create_timer(2.0).timeout
	Global.player_save.钻石 += 100
	Global.saveResource()


func _on_button双倍奖励_点击动画结束() -> void:
	pass # Replace with function body.
