class_name AbilitySystem extends Node

"""
能力组件，每个敌我单位身上都要有一个
"""


@export var attribute:角色属性

# 宿主对象标签
@export var tag:Array[String] = []

var ga_list = []
var ge_list = []

# 给角色添加技能
func create_ability(_class_path:String):
	var a:Ability = load(_class_path).new(self)
	self.ga_list.append(a)
	a.end_ability.connect(_on_Ability_end_ability.bind(a))

# 技能销毁时从列表中删除
func _on_Ability_end_ability(_ability):
	self.ga_list.erase(_ability)


# 根据tag执行技能
func try_activate_abilities_by_tag(_tag):
	for _ability in self.ga_list:
		if _ability.find_all_abilities_with_tags(_tag):
			_ability.activate_ability()

# 把effect发送到指定对象身上的AbilitySystem中
func apply_effect_to_target(_class_path:String, target:AbilitySystem):
	var e:Effect = load(_class_path).new(target)
	
	# 瞬时则直接调用不会进入ge_list中
	if e.持续时间策略 == Effect.TIME_TYPE.瞬时:
		e.run_effect()
		e.end_effect()
		return
	
	# 根据GE的配置，添加定时器
	target.ge_list.append(e)
	var t = Timer.new()
	self.add_child(t)
	if e.周期 != 0.0:
		t.wait_time = e.周期
		t.timeout.connect(_on_run_effect.bind(e,t))
		t.start()
	else:
		e.run_effect()
	get_tree().create_timer(e.最大时间).timeout.connect(_on_end_effect.bind(e,target,t))
	
func _on_run_effect(e,t):
	if e.target != null:
		e.run_effect()

func _on_end_effect(e,target,t:Timer):
	if e.target != null:
		e.end_effect()
		target.ge_list.erase(e)
		t.queue_free()
