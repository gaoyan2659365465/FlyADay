class_name Advert extends Node


signal get_reward
signal reward_skip
signal rewrad_closed
signal reward_failed
signal rewrad_videocomplete


"""
广告播放需要在Global全局类中加载
var _plugin_name = "Advertising"
var _android_plugin

func _ready():
	if Engine.has_singleton(_plugin_name):
		_android_plugin = Engine.get_singleton(_plugin_name)
		_android_plugin.initAd("12927")
"""


func _ready() -> void:
	if Global._android_plugin:
		Global._android_plugin.RewardGet.connect(func():
			get_reward.emit())
		Global._android_plugin.RewardSkip.connect(func():
			reward_skip.emit())
		Global._android_plugin.RewardFailed.connect(func():
			reward_failed.emit())
		Global._android_plugin.RewardClosed.connect(func():
			rewrad_closed.emit())
		Global._android_plugin.RewardVideoComplete.connect(func():
			rewrad_videocomplete.emit())
	else:
		print("Advertising插件加载失败")
		
func _on_reward_failed():
	print("奖励失败")

func _on_reward_skip():
	print("奖励跳过")

func _on_rewrad_closed():
	print("奖励关闭")

func _on_rewrad_videocomplete():
	print("奖励视频播放完毕")

# 播放广告调用此函数
func play_advert():
	# 向玩家请求必要权限
	if OS.get_name() == "Android":
		var e = OS.request_permissions()
	if Global._android_plugin:
		Global._android_plugin.ShowRewardVideoAd("57789")
