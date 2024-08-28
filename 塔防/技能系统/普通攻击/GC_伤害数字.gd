class_name GC_伤害数字 extends Cue


static func _get_tag():
	return ["白色伤害数字"]

# GE创建时被调用
func _ready() -> void:
	self.get_parent().AS.attribute.血量被改变.connect(_on_AS_血量被改变)
# GE激活时被调用
func process_cue():
	pass
# GE销毁时被调用
func end_cue():
	queue_free()


func 生成伤害数字(value):
	var harm_label = preload("res://塔防/伤害数字/harm_label.tscn").instantiate()
	Global.umg.add_child(harm_label)
	var tran = self.get_canvas_transform()
	harm_label.position = tran * self.global_position
	harm_label.set_text("-"+str(value))
	harm_label.颜色 = Color(1, 1, 1)
	harm_label.playAnim()

func _on_AS_血量被改变(old_value, new_value):
	生成伤害数字(old_value - new_value)
