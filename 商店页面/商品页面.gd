class_name 商品页面 extends Panel


@onready var title_panel: Panel = $"标题栏"
@onready var button_img: NinePatchRect = $"Button免费/NinePatchRect"
@onready var button2_img: NinePatchRect = $"Button金币/NinePatchRect"
@onready var button3_img: NinePatchRect = $"Button钻石/NinePatchRect"

@onready var label: Label = $"标题栏/Label"
@onready var img: TextureRect = $"商品图片"
@onready var 数量: Label = $"数量"

@onready var button免费: 超级按钮 = $"Button免费"
@onready var button金币: 超级按钮 = $"Button金币"
@onready var button钻石: 超级按钮 = $"Button钻石"

signal 购买


func 修改样式(_type):
	var _panel = self.get("theme_override_styles/panel")
	var _panel2 = title_panel.get("theme_override_styles/panel")
	if _type == "金色":
		_panel.set("bg_color",Color(1, 0.984, 0))
		_panel2.set("bg_color",Color(1, 0.827, 0))
		button_img.modulate = Color(0.741, 1, 0.365)
		button2_img.modulate = Color(0.741, 1, 0.365)
		button3_img.modulate = Color(0.741, 1, 0.365)
	elif _type == "蓝色":
		_panel.set("bg_color",Color(0, 0.518, 1))
		_panel2.set("bg_color",Color(0, 0.416, 0.796))
		button_img.modulate = Color(0.38, 0.804, 1)
		button2_img.modulate = Color(0.38, 0.804, 1)
		button3_img.modulate = Color(0.38, 0.804, 1)

func 初始化信息(_name:String, _tex:Texture2D, n:int, button_type:String, price:int):
	label.text = _name
	img.texture = _tex
	数量.text = "X"+str(n)
	if button_type == "免费按钮":
		button免费.visible = true
		button金币.visible = false
		button钻石.visible = false
		$"标题栏/红色感叹号".visible = true
	elif button_type == "金币按钮":
		button免费.visible = false
		button金币.visible = true
		button钻石.visible = false
		$"标题栏/红色感叹号".visible = false
	elif button_type == "钻石按钮":
		button免费.visible = false
		button金币.visible = false
		button钻石.visible = true
		$"标题栏/红色感叹号".visible = false
	
	# 初始化售价
	$"Button金币/MarginContainer/HBoxContainer/Label".text = str(price)
	$"Button钻石/MarginContainer/HBoxContainer/Label".text = str(price)

func 显示打折(_value:int):
	$"打折".visible = true
	$"打折/Label".text = str(_value)+"折"


func _on_button免费_点击动画结束() -> void:
	self.购买.emit()
	
	var zydx = preload("res://获取资源动效/获取资源动效.tscn").instantiate()
	zydx.设置图标(preload("res://塔防/resource/测试/icon_bcs05.png"))
	zydx.设置目标位置(Vector2(942,44))
	zydx.position = Vector2(1152,648)/2
	Global.umg.add_child(zydx)


func _on_button金币_点击动画结束() -> void:
	self.购买.emit()


func _on_button钻石_点击动画结束() -> void:
	self.购买.emit()
