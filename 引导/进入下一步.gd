class_name 进入下一步 extends Control


"""
点击空白位置进入下一步
"""
@onready var label: Label = $Label

signal 玩家点击

func 文字缩放动画():
	label.pivot_offset = label.size/2
	var tween = create_tween()
	tween.tween_property(label,"scale",Vector2(1.1,1.1),0.75)
	tween.tween_property(label,"scale",Vector2(1.0,1.0),0.75)


func _on_timer_timeout() -> void:
	文字缩放动画()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				emit_signal("玩家点击")
				queue_free()
