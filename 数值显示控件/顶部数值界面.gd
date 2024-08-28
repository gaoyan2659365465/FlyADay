class_name 顶部数值界面 extends Control


func _ready() -> void:
	Global.player_save.体力被改变.connect(_on_体力被改变)
	_on_体力被改变()
	Global.player_save.钻石被改变.connect(_on_钻石被改变)
	_on_钻石被改变()
	Global.player_save.金币被改变.connect(_on_金币被改变)
	_on_金币被改变()


func _on_体力被改变():
	var tl = Global.player_save.体力
	$"体力控件".设置文字(str(tl)+"/30")

func _on_钻石被改变():
	var zs = Global.player_save.钻石
	$"钻石控件".设置文字(str(zs))

func _on_金币被改变():
	var jb = Global.player_save.金币
	$"金币控件".设置文字(str(jb))
