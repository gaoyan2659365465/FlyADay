class_name Privacy extends Control


@onready var details_panel = $DetailsPanel
@onready var text_edit = $DetailsPanel/MarginContainer/TextEdit
@onready var text_edit_2 = $DetailsPanel/MarginContainer/TextEdit2
@onready var check_box = $CheckBox
@export var game_name = "xxxx"


func _ready():
	# 获取隐私协议是否默认勾选
	check_box.button_pressed = Global.player_save.privacy_agreement
	text_edit.text = text_edit.text.format([self.game_name])
	text_edit_2.text = text_edit.text.format([self.game_name])
	

# 玩家是否勾选相关隐私政策和用户协议
func isCheck():
	return check_box.button_pressed

# 点击用户协议
func _on_texture_button_pressed():
	details_panel.visible = true
	text_edit.visible = true
	text_edit_2.visible = false

# 点击隐私政策
func _on_texture_button2_pressed():
	details_panel.visible = true
	text_edit.visible = false
	text_edit_2.visible = true

# 隐私政策界面返回主界面
func _on_texture_button3_pressed():
	details_panel.visible = false

# 隐私协议勾选按钮
func _on_check_box_toggled(toggled_on):
	Global.player_save.privacy_agreement = toggled_on
	Global.saveResource()
