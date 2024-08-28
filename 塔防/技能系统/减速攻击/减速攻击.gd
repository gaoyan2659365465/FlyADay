class_name 减速攻击 extends Ability

func _init(_obj) -> void:
	super._init(_obj)
	# 技能标签
	self.tag = ["攻击", "减速攻击"]

# 运行技能
func activate_ability():
	super.activate_ability()
	攻击()


func 获取最前面敌人():
	var drs = self.obj.get_tree().get_nodes_in_group("敌人")
	var max_dr = [0,null]
	for i in drs:
		if i as 敌人:
			if max_dr[0] < i.path_follow.progress_ratio:
				max_dr[0] = i.path_follow.progress_ratio
				max_dr[1] = i
	return max_dr[1]

func 攻击():
	var target = 获取最前面敌人()
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
			self.obj.apply_effect_to_target("res://塔防/技能系统/减速攻击/冻梨伤害.gd", _target.AS)
			self.obj.apply_effect_to_target("res://塔防/技能系统/减速攻击/造成减速伤害.gd", _target.AS)
