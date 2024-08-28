class_name 回弹滚动框 extends ScrollContainer


var 是否按下:bool = false
var child
var bar

var 滑动数 = 0

func _ready() -> void:
	child = get_child(0)
	gui_input.connect(_on_gui_input)
	bar = get_v_scroll_bar()


func _input(event: InputEvent) -> void:
	_on_gui_input(event)


func _on_gui_input(event:InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				是否按下 = true
			else:
				是否按下 = false
				if child.position.y > 0:
					弹回动画()
				if child.position.y < (bar.max_value-bar.page)*-1:
					弹回动画2()
				滑动动画()
	if event is InputEventMouseMotion:
		if 是否按下:
			if child.position.y < 50 and child.position.y > (bar.max_value-bar.page)*-1-50:
				child.position.y += event.screen_relative.y
				scroll_vertical = child.position.y * -1
				滑动数 = event.relative.y
		#if bar.value <= bar.min_value or bar.value + bar.page >= bar.max_value:
		#	if 是否按下:
		#		if child.position.y < 50 and child.position.y > (bar.max_value-bar.page)*-1-50:
		#			child.position.y += event.screen_relative.y
		#if bar.value > bar.min_value and bar.value + bar.page < bar.max_value:
		#	if 是否按下:
		#		child.position.y += event.screen_relative.y

func 弹回动画():
	var tween = create_tween()
	tween.tween_property(child,"position",Vector2(0.0,0.0),0.2)

func 弹回动画2():
	var tween = create_tween()
	tween.tween_property(child,"position",Vector2(0.0,(bar.max_value-bar.page)*-1),0.2)

func 滑动动画():
	var tween = create_tween()
	tween.tween_property(self,"scroll_vertical",scroll_vertical-(滑动数*2),0.5)

func _on_button_button_down() -> void:
	print("999")
