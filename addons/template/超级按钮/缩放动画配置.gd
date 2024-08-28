class_name 缩放动画配置 extends 默认动画配置


var time_obj:SceneTreeTimer
## 运行指定时间后触发
@export var time = 1.75

func _ready() -> void:
	time_obj = obj.get_tree().create_timer(time)
	time_obj.connect("timeout",_on_timeout)


func 缩放动画():
	obj.pivot_offset = obj.size/2
	var tween = obj.create_tween()
	tween.tween_property(obj,"scale",Vector2(1.1,1.1),0.5)
	tween.tween_property(obj,"scale",Vector2(1.0,1.0),0.5)
	tween.tween_property(obj,"scale",Vector2(1.0,1.0),0.75)

func _on_timeout():
	缩放动画()
	time_obj = obj.get_tree().create_timer(time)
	time_obj.connect("timeout",_on_timeout)
