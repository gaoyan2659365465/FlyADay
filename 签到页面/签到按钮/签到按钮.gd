class_name 签到按钮 extends Control


func 今天是否签到():
	var time = Time.get_date_dict_from_system()
	var sign_in_data = Global.player_save.sign_in_data
	for i in sign_in_data:
		if i == time:
			return true
	return false

func _ready() -> void:
	self.刷新按钮()

func _on_button_点击动画结束() -> void:
	var qd = preload("res://签到页面/签到页面.tscn").instantiate()
	get_parent().add_child(qd)
	qd.关闭签到页面.connect(刷新按钮)

func 刷新按钮():
	if 今天是否签到():
		$Button.默认效果 = null
		$"Button/红色感叹号".visible = false
