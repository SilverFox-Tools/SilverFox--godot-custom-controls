##============================================[br]
##FileIconMapping 文件图标映射
##作者 :[br]
##——>	东方银狐 / DFYH / DF.SilverFox[br]
##———	——>	https://github.com/bilibiliDFYH[br]
##[br]
##组织 : 东方银狐的奇妙工具 / SilverFox-Tools[br]
##——>	https://github.com/SilverFox-Tools[br]
##[br]
##仓库 : 银狐的 Godot 自定义控件 / SilverFox--godot-custom-controls[br]
##——>	https://github.com/SilverFox-Tools/SilverFox--godot-custom-controls[br]
##[br]
##许可证: MIT[br]
##V0.1[br]
##============================================[br]
##@tutorial(开发者 : 东方银狐 / DFYH / DF.SilverFox):https://github.com/bilibiliDFYH
##@tutorial(组织 : 东方银狐的奇妙工具 / SilverFox-Tools) : https://github.com/SilverFox-Tools
##@tutorial(仓库 : 银狐的 Godot 自定义控件 / SilverFox--godot-custom-controls) : https://github.com/SilverFox-Tools/SilverFox--godot-custom-controls

class_name FileIconMapping
extends Resource

@export var Icon : Texture = null :
	set (value) :
		Icon = value
		emit_changed ()

@export var Extensions : Array[String] = [] :
	set (value) :
		value = Normalize (value)
		Extensions = value
		emit_changed ()

func Normalize (value : Array[String]) -> Array[String] :
	value = value.duplicate ()
	for I in value.size () :
		value[I] = value[I].to_lower ().strip_edges ()
	return value
