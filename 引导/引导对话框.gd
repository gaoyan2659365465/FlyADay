class_name 引导对话框 extends Control


@onready var 箭头: TextureRect = $"箭头"
@onready var label: Label = $Label


func 箭头移动动画():
	var tween = create_tween()
	var pos = 箭头.position
	var pos2 = 箭头.position + Vector2(0,10)
	tween.tween_property(箭头,"position",pos2,0.75)
	tween.tween_property(箭头,"position",pos,0.75)

func _on_timer_timeout() -> void:
	箭头移动动画()


func 设置内容(data):
	label.text = str(data)

# 当信号被发射时应该删除此对话界面
func 监听移除信号(sig:Signal):
	sig.connect(queue_free)
