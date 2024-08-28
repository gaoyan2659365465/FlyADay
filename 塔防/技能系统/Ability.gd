class_name Ability extends Resource

"""
逻辑层
"""
# 技能标签
var tag = []

# 宿主
var obj:AbilitySystem


# 开始技能时触发
signal start_ability
# 结束技能时触发
signal end_ability

# 技能默认Effect
var ge_class_path:String


# 初始化
func _init(_obj) -> void:
	self.obj = _obj

# 寻找tag
func find_all_abilities_with_tags(_tag:String):
	if self.tag.find(_tag) == -1:
		return false
	return true

# 运行技能
func activate_ability():
	self.start_ability.emit()
	# 寻找敌人，给敌人添加伤害Effect
	
# 结束技能
func remove_ability():
	self.end_ability.emit()
	# 由于AbilitySystem绑定了所有技能的销毁信号
	# 所以统一进行销毁，技能只需要调用此函数即可


# 生成Effect并发送给AbilitySystem组件
# 由组件管理该Effect的生命周期
func commit_effect():
	self.obj.apply_effect_to_target(ge_class_path,self.obj)
