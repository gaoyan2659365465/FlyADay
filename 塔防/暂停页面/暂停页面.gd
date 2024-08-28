class_name 暂停页面 extends Control


func _ready() -> void:
	get_tree().paused = true

# 退出战斗，返回游戏选择章节页面
func _on_button退出_点击动画结束() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://gamelevel/game_level.tscn")


# 关闭暂停页面恢复暂停
func _on_button游戏继续_点击动画结束() -> void:
	get_tree().paused = false
	queue_free()

# 打开游戏设置页面
func _on_button设置_点击动画结束() -> void:
	var sz = preload("res://设置页面/设置页面.tscn").instantiate()
	add_child(sz)
