class_name GC_毒 extends Cue



static func _get_tag():
	return ["毒"]

# GE创建时被调用
func _ready() -> void:
	var dtx = preload("res://塔防/技能系统/毒攻击/中毒特效.tscn").instantiate()
	self.add_child(dtx)
# GE激活时被调用
func process_cue():
	生成伤害数字()
# GE销毁时被调用
func end_cue():
	queue_free()


func 生成伤害数字():
	var harm_label = preload("res://塔防/伤害数字/harm_label.tscn").instantiate()
	Global.umg.add_child(harm_label)
	var tran = self.get_canvas_transform()
	harm_label.position = tran * self.global_position
	harm_label.set_text("-"+str(50))
	harm_label.颜色 = Color(0.754, 0, 0.682)
	harm_label.playAnim()
