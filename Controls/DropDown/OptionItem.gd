# ============================================
# OptionItem 选项资源
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
# V0.3
# ============================================

class_name OptionItem
extends Resource

var _parent : DropDown = null

@export var Text : String = "" :
	set (value) :
		Text = value
		_notify_parent ()

@export var Icon : Texture :
	set (value) :
		Icon = value
		_notify_parent ()

@export var Disabled : bool = false :
	set (value) :
		Disabled = value
		_notify_parent ()

func _notify_parent () :
	if _parent :
		_parent.Update_Items ("ItemDisplay")

func set_parent (parent: DropDown) :
	_parent = parent
