class_name 弹窗 extends Control


signal 关闭弹窗



func _on_button关闭_点击动画结束() -> void:
	emit_signal("关闭弹窗")
	queue_free()
