class_name 获取资源动效 extends Control

@export var 图标:CompressedTexture2D


var 目标位置

func _ready() -> void:
	播放动画()
	await get_tree().create_timer(2).timeout
	queue_free()

func 设置图标(img):
	图标 = img

func 设置目标位置(pos):
	目标位置 = pos


func 播放动画():
	for i in range(10):
		var tex = TextureRect.new()
		tex.texture = 图标
		tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex.size = Vector2(50,50)
		add_child(tex)
		
		var tween = create_tween()
		var rand_pos = Vector2(randf_range(-1,1),randf_range(-1,1))*randf_range(50,100)
		tween.tween_property(tex,"position",rand_pos,randf_range(0.3,0.4)).set_ease(Tween.EASE_OUT_IN)
		tween.tween_property(tex,"position",rand_pos,0.5)
		var offset = Vector2(randf_range(-5,5),randf_range(-5,5))
		tween.tween_property(tex,"global_position",目标位置+offset,randf_range(0.4,0.5))
		tween.finished.connect(_on_finished.bind(tex))
		
	
func _on_finished(tex):
	tex.queue_free()
	#queue_free()
