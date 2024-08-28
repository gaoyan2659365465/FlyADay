class_name 敌人 extends Node2D

@onready var icon: Sprite2D = $Icon
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var texture_progress_bar_2: TextureProgressBar = $TextureProgressBar2
@onready var AS: AbilitySystem = $AbilitySystem

var path_follow:PathFollow2D

var 允许移动:bool = true

signal 死亡信号
signal 走到尽头



func _process(delta: float) -> void:
	if not self.允许移动:
		return
	path_follow.progress += self.AS.attribute.最终速度*delta
	if path_follow.progress_ratio >= 1:
		self.走到尽头.emit()
		path_follow.queue_free()


func 生成伤害数字(value):
	var harm_label = preload("res://塔防/伤害数字/harm_label.tscn").instantiate()
	var p = get_parent().get_parent().get_parent()
	p.canvas_layer.add_child(harm_label)
	var tran = self.get_canvas_transform()
	harm_label.position = tran * self.global_position
	harm_label.set_text("-"+str(value))
	harm_label.playAnim()

func 高光血量动画(hp):
	var tween = create_tween()
	tween.tween_property(texture_progress_bar_2,"value",hp,0.2)

func 敌人缩放动画():
	var tween = create_tween()
	tween.tween_property(icon,"scale",Vector2(0.052,0.057),0.2)
	tween.tween_property(icon,"scale",Vector2(0.052,0.052),0.2)
	tween.tween_property(icon,"scale",Vector2(0.052,0.052),0.2)

func _on_timer_timeout() -> void:
	敌人缩放动画()

func 死亡鬼魂动画():
	$"鬼魂".visible = true
	var tween = create_tween()
	tween.tween_property($"鬼魂","position",Vector2(0,-55),0.5)
	await tween.finished

	
func 初始化敌人(_id, _hp, _speed):
	self.AS.attribute.最大血量 = _hp
	self.AS.attribute.血量 = _hp
	self.AS.attribute.血量被改变.connect(_on_AS_血量被改变)
	self.AS.attribute.移动速度 = _speed

func _on_AS_血量被改变(old_value, new_value):
	# 如果血量归0就消失
	var hp = self.AS.attribute.血量
	if hp >= 0:
		texture_progress_bar.value = hp
		# 高光血量
		高光血量动画(hp)
		#生成伤害数字(old_value - new_value)
	else:
		self.允许移动 = false
		Global.player_save.经验值 += 50
		emit_signal("死亡信号")
		await 死亡鬼魂动画()
		queue_free()
