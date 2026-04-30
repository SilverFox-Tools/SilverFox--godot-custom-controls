# ============================================
# HandlePath 处理路径
# 作者:
# ——>	东方银狐 / DFYH / DF.SilverFox
# ———	——>	https://github.com/bilibiliDFYH
#
# 组织: 东方银狐的奇妙工具 / SilverFox-Tools
# ——>	https://github.com/SilverFox-Tools
#
# 仓库: 银狐的 Godot 自定义控件 / SilverFox--godot-custom-controls
# ——>	https://github.com/SilverFox-Tools/SilverFox--godot-custom-controls
#
# 许可证: MIT
# V0.1
# ============================================

class_name HandlePath
extends RefCounted

static var EnvironmentVariable: Dictionary = {}

static var exe_dir = OS.get_executable_path ().get_base_dir ()

static func _static_init () :
	#region 获取环境变量
	var output = []
	EnvironmentVariable = {}
	OS.execute ("cmd" , ["/c" , "set"] , output , true)

	output[0] = output[0].replace ("\r\n" , "\n")
	output[0] = output[0].replace ("\r" , "\n")
	output = output[0].split ("\n")

	for item in output :
		var temp_int = item.find ("=")
		if temp_int != -1 :
			var key = item.substr (0 , temp_int)
			var value = item.substr (temp_int + 1)
			EnvironmentVariable [key] = value
#endregion

##格式化路径
static func StandardizedPath (Path : String) -> String :
	var newPath : String = Path.replace ("\\" , "/")
	while newPath.contains ("//" ):
		newPath = newPath.replace ("//" , "/")

	if newPath == "" or newPath == "." or newPath == "./" :
		if not exe_dir :
			newPath = exe_dir

	var lower_path = newPath.to_lower ()

	if lower_path.begins_with ("user://") :
		newPath = ProjectSettings.globalize_path (newPath)
	elif lower_path.begins_with ("res://") :
		if OS.has_feature ("editor") :
			newPath = ProjectSettings.globalize_path (newPath)
	elif lower_path.begins_with ("temp://") :
		newPath = OS.get_temp_dir ()

	while true :
		var temp_bool = true
		for temp_key in EnvironmentVariable :
			var index = lower_path.find ("%" + temp_key.to_lower () + "%")
			if index != -1 :
				var temp_value = EnvironmentVariable[temp_key]
				var temp_str = newPath.substr (index , temp_key.length () + 2 )

				newPath = newPath.replace (temp_str , temp_value)
				temp_bool = false

		if temp_bool :
			break

	newPath = newPath.rstrip ("/")

	if newPath.find ("/") == -1 :
		newPath += "/"

	return newPath
