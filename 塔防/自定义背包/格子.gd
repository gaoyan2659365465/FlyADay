class_name 格子 extends Panel

@export var 虚格子颜色:Color
@export var 实格子颜色:Color

@export var 绿格子:Color
@export var 红格子:Color


@export_enum("虚格子","实格子") var 格子状态:String = "虚格子":
	set(value):
		格子状态 = value
		var panel = get("theme_override_styles/panel")
		if 格子状态 == "虚格子":
			panel.set("bg_color",虚格子颜色)
		else:
			panel.set("bg_color",实格子颜色)

func _ready() -> void:
	格子状态 = "虚格子"


func 临时改变颜色(value):
	var panel = get("theme_override_styles/panel")
	var color = 绿格子
	if not value:
		color = 红格子
	panel.set("bg_color",color)
