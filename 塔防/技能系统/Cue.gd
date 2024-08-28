class_name Cue extends Node2D


"""
每一个GE效果都可以拥有N个Cue来显示特效
例如持续10秒毒雾，并在结束时爆炸
Cue可以监听Effect的生命周期

因为需要用到标签来创建，子类必须有类名
"""

# Effect通过标签来创建Cue
static func _get_tag():
	return []

# GE创建时被调用
func _ready() -> void:
	pass
# GE激活时被调用
func process_cue():
	pass
# GE销毁时被调用
func end_cue():
	pass
