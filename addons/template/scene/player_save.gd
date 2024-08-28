class_name PlayerSave extends Resource


"""
玩家存档

使用规范，这样数据一旦被更改，其他绑定此信号的地方就能被通知
signal set_hp
@export var hp = 100:
	set(value):
		hp = value
		set_hp.emit()
"""


# 玩家是否勾选协议
@export var privacy_agreement = false

# 当前已签到多少天
@export var sign_in_days = 0
# 签到数据
@export var sign_in_data = []

# 用于确认今天是否刷新体力
@export var 刷新体力时间 = null

# 体力值
signal 体力被改变
@export var 体力 = 30:
	set(value):
		体力 = value
		体力被改变.emit()

# 钻石
signal 钻石被改变
@export var 钻石 = 0:
	set(value):
		钻石 = value
		钻石被改变.emit()

# 金币
signal 金币被改变
@export var 金币 = 0:
	set(value):
		金币 = value
		金币被改变.emit()
		

# 当前第几章
@export var 第几章 = 1

# 当前经验
signal 经验值被改变
signal 等级被改变
@export var 经验值 = 0:
	set(value):
		经验值 = value
		经验值被改变.emit()
@export var 等级 = 1:
	set(value):
		等级 = value
		等级被改变.emit()
