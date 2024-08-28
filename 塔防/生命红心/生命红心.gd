class_name 生命红心 extends Node2D


@onready var heart: Sprite2D = $"红心"
@onready var heart2: Sprite2D = $"红心2"
@onready var heart3: Sprite2D = $"红心3"


var 红心数 = 3

signal 死亡游戏结束

func 减少红心():
	红心数 -= 1
	if 红心数 == 2:
		heart3.visible = false
	if 红心数 == 1:
		heart2.visible = false
	if 红心数 == 0:
		heart.visible = false
		死亡游戏结束.emit()

func 初始化():
	红心数 = 3
	heart3.visible = true
	heart2.visible = true
	heart.visible = true
