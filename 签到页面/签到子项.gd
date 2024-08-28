class_name 签到子项 extends Panel


@export var text:String = ""

func _ready() -> void:
	$Label.text = text

func 高亮():
	var style = get("theme_override_styles/panel")
	style.shadow_size = 10
	style.shadow_color = Color(1, 0, 0, 0.62)
	
func 领取变黑():
	var style = get("theme_override_styles/panel")
	style.shadow_size = 10
	style.shadow_color = Color(0, 0, 0, 0.62)
	
	$Panel2.visible = true

func 设置文字(_text):
	text = "第"+str(_text)+"天"
	$Label.text = text
