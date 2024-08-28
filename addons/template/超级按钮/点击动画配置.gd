class_name 点击动画配置 extends Resource



var obj:Node

func _ready() -> void:
	obj.button_down.connect(_on_button_down)
	obj.button_up.connect(_on_button_up)

# 按下按钮时按钮放大
func playAnim(target):
	target.pivot_offset = target.size/2
	var tween = obj.create_tween()
	tween.tween_property(target,"scale",Vector2(1.1,1.1),0.1)

# 松开按钮时按钮收缩回原尺寸
func playAnim2(target):
	var tween = obj.create_tween()
	tween.tween_property(target,"scale",Vector2(1.0,1.0),0.1)
	await tween.finished

func _on_button_down():
	playAnim(obj)
	# 播放按钮音效
	var audio = AudioStreamPlayer.new()
	audio.stream = preload("res://addons/template/超级按钮/resource/mp3/按钮按键.mp3")
	obj.add_child(audio)
	audio.play()
	await audio.finished
	audio.queue_free()


func _on_button_up():
	await playAnim2(obj)
	obj.emit_signal("点击动画结束")
