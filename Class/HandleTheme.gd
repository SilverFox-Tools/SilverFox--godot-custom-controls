# ============================================
# HandleTheme 处理Theme
# 作者:
# ——>	东方银狐 / DFYH / DF.SilverFox
# ———	——>	https://github.com/bilibiliDFYH
#
# 组织: 东方银狐的奇妙工具 / SilverFox-Tools
# ——>	https://github.com/SilverFox-Tools
#
# 许可证: MIT
# V0.1
# ============================================

class_name HandleTheme
extends RefCounted

class FallbackItem :
	var name : StringName
	var theme_type : StringName

	func _init (temp_name : StringName , temp_theme_type : StringName) :
		name = temp_name
		theme_type = temp_theme_type

static func get_style (theme : Theme , name : StringName , theme_type : StringName , List_FallbackItem : Array[FallbackItem] = []) -> StyleBox :
	var style : StyleBox

	if theme and theme.has_stylebox (name , theme_type) :
		style = theme.get_stylebox (name , theme_type)

	if not style and List_FallbackItem.size () > 0 :
		for Fallback : FallbackItem in List_FallbackItem :
				if theme and theme.has_stylebox (Fallback.name , Fallback.theme_type) :
					style = theme.get_stylebox (Fallback.name , Fallback.theme_type)
					break

	return style


static func get_icon (theme : Theme , name : StringName , theme_type : StringName , List_FallbackItem : Array[FallbackItem] = []) -> Texture :
	var texture : Texture

	if theme and theme.has_icon (name , theme_type) :
		texture = theme.get_icon (name , theme_type)

	if not texture and List_FallbackItem.size () > 0 :
		for Fallback : FallbackItem in List_FallbackItem :
				if theme and theme.has_icon (Fallback.name , Fallback.theme_type) :
					texture = theme.get_icon (Fallback.name , Fallback.theme_type)
					break

	return texture
