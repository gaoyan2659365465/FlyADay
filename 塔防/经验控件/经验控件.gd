class_name 经验控件 extends Control


func _ready() -> void:
	_on_经验值被改变()
	_on_等级被改变()
	Global.player_save.经验值被改变.connect(_on_经验值被改变)
	Global.player_save.等级被改变.connect(_on_等级被改变)


func _on_经验值被改变():
	var max_exp = Global.excel_data.根据等级获取所需经验(Global.player_save.等级)
	var exp = Global.player_save.经验值
	
	if max_exp[0] <= exp:
		Global.player_save.经验值 = 0
		Global.player_save.等级 += 1
		max_exp = Global.excel_data.根据等级获取所需经验(Global.player_save.等级)
		exp = Global.player_save.经验值
	
	var value = remap(exp,0,max_exp[0],0,100)
	$TextureProgressBar.value = value

func _on_等级被改变():
	$Label.text = "Lv " + str(Global.player_save.等级)
