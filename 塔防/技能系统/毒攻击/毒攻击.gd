extends Ability

func _init(_obj) -> void:
	super._init(_obj)
	# 技能标签
	self.tag = ["攻击", "中毒"]

# 运行技能
func activate_ability():
	super.activate_ability()
	攻击()

# 结束技能
func remove_ability():
	super.remove_ability()
	


func 获取敌人():
	var drs = self.obj.get_tree().get_nodes_in_group("敌人")
	if drs.size() > 0:
		var rand_id = randi_range(0,drs.size()-1)
		return drs[rand_id]
	return null

func 攻击():
	var target = 获取敌人()
	if target:
		var flyball = preload("res://塔防/飞球特效/flyball.tscn").instantiate()
		self.obj.get_parent().add_child(flyball)
		flyball.setTarget(target)
		flyball.hit.connect(_on_flyball_hit)

# 来自飞球的命中信号
func _on_flyball_hit(_target):
	if _target != null:
		if _target as 敌人:
			# 如果命中敌人，就在敌人身上的ability_system中加入“造成伤害”的effect
			self.obj.apply_effect_to_target("res://塔防/技能系统/毒攻击/GE_蘑菇伤害.gd", _target.AS)
			self.obj.apply_effect_to_target("res://塔防/技能系统/毒攻击/GE_造成毒伤害.gd", _target.AS)
