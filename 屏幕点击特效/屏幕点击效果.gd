class_name 屏幕点击效果 extends Control

@onready var 圆圈扩散: GPUParticles2D = $"圆圈扩散"
@onready var 粒子四散: GPUParticles2D = $"圆圈扩散/粒子四散"


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var a = 圆圈扩散.duplicate()
				var b = 粒子四散.duplicate()
				self.add_child(a)
				a.add_child(b)
				a.global_position = event.global_position
				a.emitting = true
				b.emitting = true
				a.connect("finished",_on_finished.bind(a))

func _on_finished(a):
	a.queue_free()
