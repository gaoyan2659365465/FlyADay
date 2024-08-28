class_name 超级按钮 extends TextureButton


@export var 点击效果:点击动画配置
@export var 默认效果:默认动画配置

signal 点击动画结束

func _ready() -> void:
	if 点击效果:
		点击效果.obj = self
		点击效果._ready()
	if 默认效果:
		默认效果.obj = self
		默认效果._ready()
