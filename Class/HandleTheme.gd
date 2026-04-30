# ============================================
# HandleTheme 处理Theme
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
# V1.1
# ============================================

class_name HandleTheme
extends RefCounted

##默认Theme , 自动获取项目设置里的默认Theme , 不应该以任何代码修改此变量的值[br]
##可以通过 [method Refresh_DefaultTheme] 刷新此变量
static var DefaultTheme : Theme = ThemeDB.get_project_theme ()
##编辑器Theme , 自动Godot编辑器自带的Theme , 不应该以任何代码修改此变量的值[br]
##可以通过 [method Refresh_DefaultTheme] 刷新此变量
static var EditorTheme : Theme = ThemeDB.get_default_theme ()


class FallbackItem :
	var name : StringName
	var theme_type : StringName

	func _init (temp_name : StringName , temp_theme_type : StringName) :
		name = temp_name
		theme_type = temp_theme_type


static func get_style (theme : Theme , name : StringName , theme_type : StringName , List_FallbackItem : Array[FallbackItem] = []) -> StyleBox :
	var style : StyleBox

	if theme :
		if theme.has_stylebox (name , theme_type) :
			style = theme.get_stylebox (name , theme_type)

		if not style and List_FallbackItem.size () > 0 :
			for Fallback : FallbackItem in List_FallbackItem :
				if theme.has_stylebox (Fallback.name , Fallback.theme_type) :
					style = theme.get_stylebox (Fallback.name , Fallback.theme_type)
					break

	return style

static func get_icon (theme : Theme , name : StringName , theme_type : StringName , List_FallbackItem : Array[FallbackItem] = []) -> Texture :
	var texture : Texture

	if theme :
		if theme.has_icon (name , theme_type) :
			texture = theme.get_icon (name , theme_type)

		if not texture and List_FallbackItem.size () > 0 :
			for Fallback : FallbackItem in List_FallbackItem :
				if theme.has_icon (Fallback.name , Fallback.theme_type) :
					texture = theme.get_icon (Fallback.name , Fallback.theme_type)
					break

	return texture


static func apply_style (
		node : Control , StyleName : String ,
		Theme_ID : String , Theme_Type : String ,
		FallbackTheme_ID : String , FallbackTheme_Type : String ,
		AllowOverrides : bool = false , ThemeOverrides : StyleBox = null ,
		theme : Theme = null
		) -> void :
	if not theme : theme = node.theme

	if AllowOverrides and ThemeOverrides :
		node.add_theme_stylebox_override (StyleName , ThemeOverrides)
	else :
		var style : StyleBox
		var temp_fallback_item = FallbackItem.new (FallbackTheme_ID , FallbackTheme_Type)

		style = get_style (theme , Theme_ID , Theme_Type , [temp_fallback_item])
		if !style :
			style = get_style (DefaultTheme , Theme_ID , Theme_Type , [temp_fallback_item])
		if !style :
			style = get_style (EditorTheme , temp_fallback_item.name , temp_fallback_item.theme_type)

		if style :
			node.add_theme_stylebox_override (StyleName , style)


static func Refresh_DefaultTheme () :
	DefaultTheme = ThemeDB.get_project_theme ()
	EditorTheme = ThemeDB.get_default_theme ()
