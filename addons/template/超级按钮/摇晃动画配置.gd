class_name 摇晃动画配置 extends 默认动画配置



var time_obj:SceneTreeTimer
## 运行指定时间后触发
@export var time = 1

func _ready() -> void:
	time_obj = obj.get_tree().create_timer(time)
	time_obj.connect("timeout",_on_timeout)


func 旋转动画():
	obj.pivot_offset = obj.size/2
	var tween = obj.create_tween()
	tween.tween_property(obj,"rotation_degrees",5,0.1)
	tween.tween_property(obj,"rotation_degrees",-5,0.1)
	tween.tween_property(obj,"rotation_degrees",5,0.1)
	tween.tween_property(obj,"rotation_degrees",-5,0.1)
	tween.tween_property(obj,"rotation_degrees",0,0.1)

func _on_timeout():
	旋转动画()
	time_obj = obj.get_tree().create_timer(time)
	time_obj.connect("timeout",_on_timeout)
