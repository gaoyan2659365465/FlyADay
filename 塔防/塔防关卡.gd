class_name 塔防关卡 extends Node2D


"""
不同怪物速度不同
需要有怪物总数，轻松设置每一关的怪物数量和种类（数值不同）

"""



@onready var path_2d: Path2D = $Path2D
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var timer: Timer = $Timer
@onready var camera_2d: Camera2D = $Camera2D

var 第几章:int = 1
var 第几波:int = 1

var 是否正在生成:bool = false

var 银币:int = 0:
	set(value):
		银币 = value
		$"CanvasLayer/银币".设置文字(str(value))

signal 敌人全歼



func _ready() -> void:
	$"CanvasLayer/经验控件".visible = false
	self.第几章 = Global.player_save.第几章
	更新UI界面()

func 更新UI界面():
	var bs = Global.excel_data.根据章节获取最大波数(第几章)
	var a = 第几章
	var b = ""
	if a == 1:
		b = "一"
	elif a == 2:
		b = "二"
	elif a == 3:
		b = "三"
	elif a == 4:
		b = "四"
	elif a == 5:
		b = "五"
	elif a == 6:
		b = "六"
	elif a == 7:
		b = "七"
	elif a == 8:
		b = "八"
	elif a == 9:
		b = "九"
	elif a == 10:
		b = "十"
	$"CanvasLayer/Label章".text = "第"+b+"章"
	$"CanvasLayer/Label波".text = "第"+str(第几波)+"/"+str(bs[0])+"波"
	

func 开始新一波():
	是否正在生成 = true
	var data = Global.excel_data.根据章节和波数获取出怪顺序(1, 1)
	for i in data:
		var 出怪步骤 = i[0]
		var 敌人ID = i[1]
		var 数量 = i[2]
		var 间隔时间 = i[3]
		for n in range(数量):
			生成敌人(敌人ID)
			await get_tree().create_timer(0.05).timeout
		await get_tree().create_timer(间隔时间).timeout
	是否正在生成 = false
	# 查询是否全歼敌人
	timer.start()


func 生成敌人(_id):
	var pf = PathFollow2D.new()
	pf.rotates = false
	pf.loop = false
	path_2d.add_child(pf)
	
	# 血量公式：
	# 血量 = 基础值+(波数^指数系数)*章节数*整体缩放系数
	var 指数系数 = 1.5
	var 整体缩放系数 = 20.0
	var 基础值 = 100.0

	var 血量 = 基础值+(float(第几波)**指数系数)*float(第几章)*整体缩放系数
	#print("     章数："+str(第几章) + "    波数："+str(第几波))
	#print("血量：" + str(血量))
	
	# 速度公式，只看波数不看章节
	# 波数越高速度越快
	# 每种敌人有基础速度 * 环境速度加成
	# 200-400之间
	var speed = remap(第几波,1,20,200,400)
	#print(speed)
	var dr = preload("res://塔防/敌人.tscn").instantiate()
	dr.path_follow = pf
	pf.add_child(dr)
	dr.初始化敌人(_id,血量,speed)
	dr.走到尽头.connect(_on_敌人_走到尽头)


func _on_timer_timeout() -> void:
	# 检查敌人是否被全歼
	if 是否正在生成:
		return
	var drs = get_tree().get_nodes_in_group("敌人")
	if drs.size() == 0:
		emit_signal("敌人全歼")
		timer.stop()
		
		宝箱动画爆银币()
		await get_tree().create_timer(2.0).timeout
		var bs = Global.excel_data.根据章节获取最大波数(第几章)
		if 第几波 >= bs[0]:
			print("需要退出关卡返回游戏关卡")
			var sl = preload("res://胜利页面/胜利页面.tscn").instantiate()
			$CanvasLayer.add_child(sl)
			
			return
		self.第几波 += 1
		更新UI界面()
		$"自定义背包".结束战斗()
		$"CanvasLayer/经验控件".visible = false


func _on_button暂停_点击动画结束() -> void:
	var zt = preload("res://塔防/暂停页面/暂停页面.tscn").instantiate()
	$CanvasLayer.add_child(zt)
	

func 宝箱动画爆银币():
	var bx = preload("res://塔防/宝箱效果/宝箱效果.tscn").instantiate()
	canvas_layer.add_child(bx)
	await get_tree().create_timer(2).timeout
	bx.queue_free()
	
	var zydx = preload("res://获取资源动效/获取资源动效.tscn").instantiate()
	zydx.设置图标(preload("res://塔防/resource/银币.png"))
	zydx.设置目标位置(Vector2(987,42))
	canvas_layer.add_child(zydx)
	zydx.position = $CanvasLayer/Control.size/2
	await get_tree().create_timer(2.0).timeout
	银币 += randi_range(15,30)



func _on_自定义背包_开始战斗() -> void:
	$"CanvasLayer/经验控件".visible = true
	开始新一波()

# 消耗银币
func _on_自定义背包_刷新道具() -> void:
	var a = 银币 - 15
	if a >= 0:
		银币 = a


func _on_敌人_走到尽头():
	$"生命红心".减少红心()

func _on_生命红心_死亡游戏结束() -> void:
	# 需要显示游戏失败页面
	var fh = preload("res://塔防/复活页面/复活页面.tscn").instantiate()
	$CanvasLayer.add_child(fh)
	fh.connect("复活",_on_复活页面_复活)

func _on_复活页面_复活():
	# 重置生命
	$"生命红心".初始化()
	# 停止查询是否结束战斗
	timer.stop()
	# 删除所有敌人
	var drs = get_tree().get_nodes_in_group("敌人")
	for i in drs:
		if i as 敌人:
			i.queue_free()
	# 进入背包编辑
	$"自定义背包".结束战斗()
	$"CanvasLayer/经验控件".visible = false
	
	# 获得15银币
	var zydx = preload("res://获取资源动效/获取资源动效.tscn").instantiate()
	zydx.设置图标(preload("res://塔防/resource/银币.png"))
	zydx.设置目标位置(Vector2(987,42))
	canvas_layer.add_child(zydx)
	zydx.position = $CanvasLayer/Control.size/2
	await get_tree().create_timer(2.0).timeout
	银币 += 15
	
