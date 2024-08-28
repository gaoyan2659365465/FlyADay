class_name 小手动效 extends Control

@onready var 手: TextureRect = $"手"


func 小手动画():
	var tween = create_tween()
	tween.tween_property(手,"scale",Vector2(1.1,1.1),0.5).set_ease(Tween.EASE_OUT)
	tween.tween_property(手,"scale",Vector2(1.0,1.0),0.5).set_ease(Tween.EASE_OUT)


func _on_timer_timeout() -> void:
	小手动画()
