class_name 拖拽物 extends Control


var pressed:bool = false

signal 正在拖拽(target)
signal 拖拽完毕(target)
signal 拖拽开始(target)

func _ready() -> void:
	if not gui_input.is_connected(_on_gui_input):
		gui_input.connect(_on_gui_input)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			self.pressed = event.pressed
			if event.pressed:
				emit_signal("拖拽开始",self)
			else:
				emit_signal("拖拽完毕",self)
	if event is InputEventMouseMotion:
		if self.pressed:
			var tran = get_canvas_transform().affine_inverse()
			self.global_position = tran*(event.global_position - size/2)
			emit_signal("正在拖拽",self)


func 吸附动画(_pos):
	var tween = create_tween()
	tween.tween_property(self,"global_position",_pos,0.2)
