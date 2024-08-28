class_name 获得物品页面 extends Control


"""
需要设置获取了什么物品
如果是资源的话怎么对接《获取资源动效》
物品使用什么数据格式
"""

signal 点击领取

@onready var p_coloured_ribbon: GPUParticles2D = $PColouredRibbon
@onready var p_coloured_ribbon_2: GPUParticles2D = $PColouredRibbon2



func _ready() -> void:
	p_coloured_ribbon.emitting = true
	p_coloured_ribbon_2.emitting = true


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				emit_signal("点击领取")
				queue_free()
