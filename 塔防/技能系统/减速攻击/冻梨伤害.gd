extends Effect


func _get_cue_tag():
	return ["白色伤害数字"]

# 对宿主身上的角色属性数据进行修改
# 在AbilitySystem组件中进行生命周期管理并调用
func run_effect():
	super.run_effect()
	self.target.attribute.血量 -= 60
