extends Effect


func _init(_target) -> void:
	super._init(_target)
	self.持续时间策略 = TIME_TYPE.拥有持续时间
	self.周期 = 0.0
	self.最大时间 = 2.0


func _get_cue_tag():
	return ["冰"]

# 对宿主身上的角色属性数据进行修改
# 在AbilitySystem组件中进行生命周期管理并调用
func run_effect():
	super.run_effect()
	self.target.attribute.减速效果 = 0.9


# 当临时效果结束时需要还原数据
func end_effect():
	super.end_effect()
	self.target.attribute.减速效果 = 0.0
