extends Node


var save_file_path = "user://save/"
var save_file_name = "PlayerSave.tres"

var player_save:PlayerSave

# 专门用于读取表格数据
var excel_data:ExcelData = ExcelData.new()

# uuid
var uuid:UUID = UUID.new()

# 用于顶层的UI，比如金币收集效果
var umg:CanvasLayer = CanvasLayer.new()

# 用于广告
var _android_plugin

func _ready():
	self.add_child(excel_data)
	self.add_child(uuid)
	self.add_child(umg)
	
	# 加载广告插件
	var _plugin_name = "Advertising"
	if Engine.has_singleton(_plugin_name):
		_android_plugin = Engine.get_singleton(_plugin_name)
		_android_plugin.initAd("12927")
	
	# 如果目录不存在则创建存档目录
	var dir = DirAccess.open("user://")
	if not dir.dir_exists(save_file_path):
		dir.make_dir(save_file_path)
		
	#判断存档文件是否存在
	if ResourceLoader.exists(save_file_path+save_file_name):
		player_save = ResourceLoader.load(save_file_path+save_file_name)
	else:
		player_save = PlayerSave.new()
		saveResource()

# 保存当前资源
func saveResource():
	ResourceSaver.save(player_save,save_file_path+save_file_name)
