class_name Effect extends Resource

"""
数据层

瞬时、无限、有持续时间（由能力系统组件管理GE的生命周期）
"""
enum TIME_TYPE{
	瞬时,
	无限,
	拥有持续时间
}
var 持续时间策略:TIME_TYPE = TIME_TYPE.瞬时

# 以秒为单位的周期，时间到就触发一次该Effect
var 周期:float = 0.0
# 以秒为单位的周期，时间到就销毁该Effect（仅 拥有持续时间 状态下生效）
var 最大时间:float = 0.0

# 生成的cue列表，自动生成不需要手动填
var cue_list = []
# 根据标签生成相关Cue特效,需要子类重载
func _get_cue_tag():
	return []

# 当前的AbilitySystem
var target:AbilitySystem

# Effect被生成时触发，创建相关Cue特效
func _init(_target) -> void:
	self.target = _target
	self.create_cue()

# 对宿主身上的角色属性数据进行修改
# 在AbilitySystem组件中进行生命周期管理并调用
func run_effect():
	for i in self.cue_list:
		if i == null:
			self.cue_list.erase(i)
		else:
			i.process_cue()

# 当临时效果结束时需要还原数据
func end_effect():
	for i in self.cue_list:
		if i == null:
			self.cue_list.erase(i)
		else:
			i.end_cue()

# 根据标签创建cue,并赋予到相应对象的AbilitySystem组件中
func create_cue():
	if _get_cue_tag().size() == 0:
		return
	var _class_list = ProjectSettings.get_global_class_list()
	# 获取所有找到的cue
	for _class in _class_list:
		if _class["base"] == "Cue":
			# 对每一个Cue的标签进行检查
			for _tag in _get_cue_tag():
				var cue_class = load(_class["path"])
				# cue类里面拿到tag数组
				for i in cue_class._get_tag():
					if _tag == i:
						var cue = cue_class.new()
						self.cue_list.append(cue)
						# 因为target是AbilitySystem组件，继承自Node所以位置被阻断
						# 所以需要直接在对象身上添加
						self.target.get_parent().add_child(cue)
