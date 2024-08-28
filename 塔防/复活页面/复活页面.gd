class_name 复活页面 extends Control


"""
游戏失败后会进入看广告复活页面
"""
signal 复活

func _ready() -> void:
	get_tree().paused = true


func _on_button关闭_点击动画结束() -> void:
	# 进入游戏失败页面
	var sb = preload("res://塔防/失败页面/失败页面.tscn").instantiate()
	get_parent().add_child(sb)
	queue_free()


func _on_button看广告复活_点击动画结束() -> void:
	self.复活.emit()
	get_tree().paused = false
	queue_free()
