class_name GC_冰 extends Cue


static func _get_tag():
	return ["冰"]

# GE创建时被调用
func _ready() -> void:
	var dtx = preload("res://塔防/技能系统/减速攻击/冰特效.tscn").instantiate()
	self.add_child(dtx)
# GE激活时被调用
func process_cue():
	pass
# GE销毁时被调用
func end_cue():
	queue_free()
