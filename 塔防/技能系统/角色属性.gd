class_name 角色属性 extends Resource

# 基础数值层
signal 血量被改变(old_value, new_value)
@export var 血量 = 100:
	set(v):
		血量被改变.emit(血量,v)
		血量 = v
		

signal 最大血量被改变
@export var 最大血量 = 100:
	set(v):
		最大血量 = v
		最大血量被改变.emit()

signal 移动速度被改变
@export var 移动速度 = 200:
	set(v):
		移动速度 = v
		移动速度被改变.emit()

# 技能加成层
signal 减速效果被改变
@export var 减速效果 = 0.0:
	set(v):
		减速效果 = v
		减速效果被改变.emit()


# 最终层
@export var 最终速度 = 200:
	get():
		return 移动速度 - 移动速度*减速效果
