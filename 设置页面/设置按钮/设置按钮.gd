class_name 设置按钮 extends Control




func _on_button_点击动画结束() -> void:
	var sz = preload("res://设置页面/设置页面.tscn").instantiate()
	get_parent().add_child(sz)
