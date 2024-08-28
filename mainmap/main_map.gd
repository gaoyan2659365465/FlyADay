class_name MainMap extends Node2D


@onready var privacy: Privacy = $CanvasLayer/Privacy


func _on_button开始游戏_button_down() -> void:
	if privacy.isCheck():
		get_tree().change_scene_to_file("res://gamelevel/game_level.tscn")


func _on_button退出游戏_button_down() -> void:
	# 关闭游戏
	get_tree().quit()
