class_name 左右换图页面 extends Control


@export var 页数:int = 5

var 当前页:int = 0

@export var 图片数组:Array[CompressedTexture2D]

@onready var 遮罩层: Control = $"遮罩层"
@onready var texture_rect: TextureRect = $"遮罩层/TextureRect"

signal 切换页(n)

func _ready() -> void:
	texture_rect.texture = 图片数组[当前页]

func 切换图片(direction):
	var new_pos = Vector2.ZERO
	var pos = Vector2(38,0)
	var lod_pos = Vector2.ZERO
	if direction == 0:
		new_pos = Vector2(38-500,0)
		lod_pos = Vector2(38+500,0)
	else:
		new_pos = Vector2(38+500,0)
		lod_pos = Vector2(38-500,0)
	
	var new_tex = texture_rect.duplicate()
	new_tex.texture = 图片数组[当前页]
	遮罩层.add_child(new_tex)
	new_tex.position = new_pos
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(new_tex,"position",pos,0.5)
	tween.tween_property(texture_rect,"position",lod_pos,0.5)
	await tween.finished
	texture_rect.queue_free()
	texture_rect = new_tex



func _on_button左_点击动画结束() -> void:
	var n = 当前页 - 1
	if n > 0:
		当前页 = n
		$"Button左".visible = true
		$"Button右".visible = true
	else:
		当前页 = 0
		$"Button左".visible = false
	切换图片(0)
	emit_signal("切换页",当前页)


func _on_button右_点击动画结束() -> void:
	var n = 当前页 + 1
	if n < 页数:
		当前页 = n
		$"Button左".visible = true
		$"Button右".visible = true
	else:
		当前页 = 页数
		$"Button右".visible = false
	切换图片(1)
	emit_signal("切换页",当前页)
